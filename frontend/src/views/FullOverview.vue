<!--
  @模块：FullOverview.vue — 学习进度全览
  @页面用途：展示指定课程（可切换）全部学生的学习进度，不受分页限制一次展示，
            底部提供"导出Excel"和"导出PDF"两个按钮。
  @数据流：
    1. 组件挂载 → 读取路由 courseId 或加载 GET /courses?status=active 课程列表
    2. 选择课程 → 循环调用 GET /stats/class-overview?course_id=X&page=N&page_size=100 拉取全部分页
    3. 前端汇总全部学生 → 渲染表格 / 导出
  @后端API：
    - GET /courses?status=active                    课程列表
    - GET /stats/class-overview?course_id=X         学生学习概览（每页最多100条，循环拉取）
    - GET /notify/export?course_id=X                导出全部学生进度（Excel blob）
  @依赖：
    - utils/api：封装 axios 的请求工具
-->
<template>
  <div class="full-overview">
    <!-- 顶栏：标题(左对齐) + 科目选择(正中间) + 导出/返回(靠右) -->
    <div class="overview-header no-print">
      <h2 class="page-title">学习进度全览</h2>
      <div class="selector">
        <select v-model="selectedCourseId" @change="resetClassFilter" :disabled="loading">
          <option value="">请选择课程</option>
          <option v-for="c in courses" :key="c.id" :value="c.id">{{ c.title }}</option>
        </select>
        <select v-model="selectedClass" @change="loadAll" :disabled="loading" class="class-select">
          <option value="">全部班级</option>
          <option v-for="cn in classNames" :key="cn" :value="cn">{{ cn }}</option>
        </select>
      </div>
      <div class="header-actions">
        <button class="btn primary" :disabled="exporting" @click="exportExcel">
          {{ exporting ? '导出中...' : '导出 Excel' }}
        </button>
        <button class="btn" @click="exportPdf">导出 PDF</button>
        <button class="btn back-btn" @click="goBack">返回看板</button>
      </div>
    </div>

    <div v-if="!selectedCourseId" class="empty">请选择一门课程查看全览</div>

    <template v-else>
      <!-- 汇总信息 -->
      <div class="overview-cards no-print">
        <div class="card">
          <div class="card-num">{{ allStudents.length }}</div>
          <div class="card-label">学生总数</div>
        </div>
        <div class="card">
          <div class="card-num">{{ overview.completed_students }}</div>
          <div class="card-label">已完成</div>
        </div>
        <div class="card">
          <div class="card-num">{{ overview.total_students - overview.completed_students }}</div>
          <div class="card-label">未完成</div>
        </div>
        <div class="card">
          <div class="card-num primary">{{ overview.section_count || 0 }}</div>
          <div class="card-label">课程小节</div>
        </div>
      </div>

      <!-- 全部学生表格 -->
      <div class="student-section">
        <div class="section-header">
          <h3>全部学生进度</h3>
          <span class="total-hint" v-if="!loading">共 {{ allStudents.length }} 人</span>
        </div>

        <div v-if="loading" class="loading-cell">加载中...</div>
        <div v-else-if="error" class="task-error">{{ error }}</div>
        <div v-else class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>姓名</th>
                <th>班级</th>
                <th>有效时长(分)</th>
                <th>总时长(分)</th>
                <th>完成进度</th>
                <th>视频进度(%)</th>
                <th>完成率</th>
                <th>状态</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="s in allStudents" :key="s.user_id" :class="{ incomplete: !s.is_completed }">
                <td>{{ s.name }}</td>
                <td>{{ s.class_name || '-' }}</td>
                <td>{{ s.effective_minutes }}</td>
                <td>{{ s.require_minutes || '-' }}</td>
                <td>{{ s.completed_sections }}/{{ s.total_sections }}</td>
                <td>{{ s.video_progress }}</td>
                <td>{{ formatPct(s.completion_rate) }}</td>
                <td>
                  <span class="tag" :class="s.is_completed ? 'done' : 'warn'">
                    {{ s.is_completed ? '已完成' : (s.completed_sections > 0 ? '未完成' : '未开始') }}
                  </span>
                </td>
              </tr>
              <tr v-if="allStudents.length === 0">
                <td colspan="8" class="empty-cell">暂无学生数据</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      </template>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../utils/api'

const route = useRoute()
const router = useRouter()

const courses = ref([])
const selectedCourseId = ref('')
const allStudents = ref([])
const classNames = ref([])   // 班级下拉选项（"全部班级" + 各班级）
const selectedClass = ref('') // 当前选中班级，'' = 全部班级
const overview = ref({ total_students: 0, completed_students: 0, section_count: 0 })
const loading = ref(false)
const exporting = ref(false)
const error = ref('')

/** 返回教师看板 */
function goBack() {
  router.push('/teacher')
}

/** 格式化成百分比：0.5 -> 50% */
function formatPct(rate) {
  if (rate === null || rate === undefined || isNaN(rate)) return '-'
  return Math.round(rate * 100) + '%'
}

/**
 * 拉取全部学生。
 * 后端 /stats/class-overview 支持 class_name 参数过滤，单页最多100条(page_size<=100)。
 * 优化：先取第1页获取 total_pages，其余页用 Promise.all 并行拉取，
 *       避免原先一页页串行等待造成 2~3 秒延迟。
 */
async function loadAll() {
  if (!selectedCourseId.value) return
  loading.value = true
  error.value = ''
  allStudents.value = []
  const pageSize = 100
  const courseId = selectedCourseId.value
  const paramsOf = (page) => {
    const p = { course_id: courseId, page, page_size: pageSize, sort_by: 'name' }
    if (selectedClass.value) p.class_name = selectedClass.value // 班级过滤（后端已支持）
    return p
  }
  try {
    // 第1页：拿到 overview 和总页数
    const firstRes = await api.get('/stats/class-overview', { params: paramsOf(1) })
    if (firstRes.data.code !== 0) {
      error.value = firstRes.data.message || '加载失败'
      return
    }
    const firstData = firstRes.data.data
    overview.value = {
      total_students: firstData.total_students || 0,
      completed_students: firstData.completed_students || 0,
      section_count: firstData.section_count || 0,
    }
    const totalPages = firstData.pagination?.total_pages || 1
    const pageResults = [firstData.students || []]

    // 其余页并行拉取
    if (totalPages > 1) {
      const restRes = await Promise.all(
        Array.from({ length: totalPages - 1 }, (_, i) =>
          api.get('/stats/class-overview', { params: paramsOf(i + 2) })
        )
      )
      restRes.forEach((r) => {
        if (r.data.code === 0) pageResults.push(r.data.data.students || [])
      })
    }
    allStudents.value = pageResults.flat()
    // 切到"全部班级"时，从全量数据聚合班级下拉选项
    if (!selectedClass.value) {
      const set = new Set(allStudents.value.map((s) => s.class_name).filter(Boolean))
      classNames.value = [...set].sort((a, b) => a.localeCompare(b, 'zh'))
    }
  } catch (e) {
    error.value = '加载失败: ' + (e?.message || '未知错误')
  } finally {
    loading.value = false
  }
}

/** 切换班级：重置为全部班级并重新加载（不带 class_name 全量拉取，用于重新聚合班级选项） */
function resetClassFilter() {
  selectedClass.value = ''
  loadAll()
}

/** 加载课程列表（仅用于科目选择下拉） */
async function loadCourses() {
  try {
    const res = await api.get('/courses?status=active')
    if (res.data.code === 0) {
      courses.value = res.data.data || []
      // 若尚未选定课程（路由未带 courseId），取默认课程
      if (!selectedCourseId.value && courses.value.length > 0) {
        const preferred = courses.value.find((c) => c.description && c.require_minutes >= 60)
        selectedCourseId.value = preferred ? preferred.id : courses.value[0].id
        await loadAll()
      }
    }
  } catch (e) {
    error.value = '课程加载失败: ' + (e?.message || '未知错误')
  }
}

/** 导出 Excel：复用教师看板 /notify/export 逻辑 */
async function exportExcel() {
  if (!selectedCourseId.value) return
  exporting.value = true
  try {
    const res = await api.get('/notify/export', {
      params: { course_id: selectedCourseId.value },
      responseType: 'blob',
    })
    const blob = new Blob([res.data], {
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `study_report_${selectedCourseId.value}.xlsx`
    a.click()
    window.URL.revokeObjectURL(url)
  } catch (e) {
    alert('导出失败: ' + (e.response?.statusText || e.message))
  } finally {
    exporting.value = false
  }
}

/** 导出 PDF：调用浏览器打印，另存为 PDF */
function exportPdf() {
  window.print()
}

onMounted(() => {
  const raw = route.params.courseId
  if (raw) {
    // 路由已带课程：立即加载数据 + 并行加载课程下拉，不等课程列表
    selectedCourseId.value = raw
    loadAll()
    loadCourses()
  } else {
    // 无课程参数：先加载课程列表，再取默认课程并加载数据
    loadCourses()
  }
})
</script>

<style scoped>
/* 根容器：与顶栏标题左对齐（顶栏 padding-left 16px） */
.full-overview { padding: 16px; }

/* 顶栏布局：标题(左) + 科目选择(正中间) + 导出/返回(靠右) */
.overview-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}
.overview-header .page-title {
  font-size: 18px;               /* 比顶栏"在线学习平台"(16px)稍大 */
  font-weight: 600;
  color: #333;
  margin: 0;
  white-space: nowrap;
}
.overview-header .selector {
  flex: 1;
  display: flex;
  justify-content: center;       /* 科目选择水平居中 */
}
.overview-header .selector select {
  padding: 8px 12px;
  border: 1px solid #d9d9d9;
  border-radius: 6px;
  font-size: 14px;
  min-width: 260px;
  cursor: pointer;
}
.overview-header .selector select.class-select {
  min-width: 150px;
  margin-left: 8px;
}
.overview-header .header-actions {
  display: flex;
  gap: 8px;
  align-items: center;
  white-space: nowrap;
}
.overview-header .header-actions .btn { white-space: nowrap; }

.overview-cards { display: grid; grid-template-columns: repeat(4, 1fr); gap: 12px; margin-bottom: 16px; }
.card {
  background: #fff; border-radius: 8px; padding: 16px; text-align: center;
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
}
.card-num { font-size: 26px; font-weight: 700; color: #333; }
.card-num.warn { color: #ff4d4f; }
.card-num.primary { color: #1890ff; }
.card-label { font-size: 13px; color: #999; margin-top: 4px; }

.student-section { background: #fff; border-radius: 8px; padding: 16px; margin-bottom: 16px; box-shadow: 0 1px 4px rgba(0,0,0,0.06); }
.section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px; flex-wrap: wrap; gap: 8px; }
.section-header h3 { font-size: 16px; margin: 0; }
.total-hint { font-size: 12px; color: #999; }

.table-wrapper { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; font-size: 13px; }
th { background: #f5f7fa; padding: 10px 8px; text-align: left; font-weight: 600; color: #666; }
td { padding: 10px 8px; border-bottom: 1px solid #f0f0f0; }

tr.incomplete { background: #fff7e6; }
.tag { font-size: 12px; padding: 2px 8px; border-radius: 10px; white-space: nowrap; }
.tag.done { background: #f6ffed; color: #52c41a; }
.tag.warn { background: #fff7e6; color: #faad14; }

.empty-cell { text-align: center; color: #999; padding: 30px; }
.loading-cell { text-align: center; color: #999; padding: 30px; }
.task-error { text-align: center; color: #ff4d4f; padding: 16px; }
.empty { text-align: center; padding: 40px; color: #999; }

.actions { display: flex; gap: 10px; flex-wrap: wrap; margin-top: 8px; }
.btn {
  padding: 8px 20px; border: 1px solid #d9d9d9; border-radius: 6px;
  background: #fff; font-size: 14px; cursor: pointer;
}
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
.btn.primary { background: #1890ff; color: #fff; border-color: #1890ff; }

/* 打印样式：隐藏非表格元素，避免导出PDF带工具栏 */
@media print {
  .no-print { display: none !important; }
  .full-overview { padding: 0; }
  .overview-cards { display: none; }
  .student-section { box-shadow: none; padding: 0; }
  table { font-size: 11px; }
  th, td { padding: 6px 6px; }
}
</style>