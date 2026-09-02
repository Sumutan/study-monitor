<!--
  @模块：PsyPromo.vue — 「智慧学习 · AI赋能」产品宣传页（独立页面，通过链接访问）
  @页面用途：对外推广用宣传页（无需登录）。左侧为产品介绍文字（看课学习监督平台
            功能与亮点），右侧为通栏主视觉：模糊化校园背景 + 文字叠加层。
  @访问路径：/#/psy-promo（hash路由，公开页面，无角色限制）
  @数据流：纯静态展示页面，无后端交互；背景为内联 SVG（高斯模糊校园场景），无外部图片依赖。
-->
<template>
  <div class="promo-page">
    <div class="promo-card">
      <!-- 左侧：宣传文字 -->
      <div class="promo-left">
        <h1 class="p-title">智慧学习 · AI赋能</h1>
        <div class="p-slogan">观看 · 督导 · 反馈 · 激励</div>

        <p class="p-para">
          面向学校与培训机构的在线学习过程监督平台，打通"教师发布课程—学生观看学习—过程实时督导—数据反馈闭环"全流程。支持课程-小节两级管理、视频课程、小节作业、签到、排行榜、公告等完整学习场景；钉钉免登、移动端原生适配，学生打开即用，老师开箱即管。
        </p>
        <p class="p-para">
          直击线上学习"看不见、管不住、说不清"三大痛点：独创的有效学习时长采集引擎，只记录真实观看，杜绝挂机刷课；教师看板与钉钉群推送双管齐下，未完成学生一目了然，学习提醒、每日报告自动送达班级群；数据一键导出
          Excel，让每一次家校沟通都有据可依。
        </p>
        <p class="p-para">
          作业批改同样由 AI 赋能：学生拍照上传作业，智能 Agent
          自动逐题识别、智能判分，即时生成含正确率统计的个性化批改报告，错题一目了然；教师可预约定时自动批改、一键重批，把老师从繁重的重复批改中解放出来，让精力回归教学本身。
        </p>

        <h2 class="p-subtitle">平台核心能力</h2>

        <div class="p-item">
          <div class="p-icon">
            <!-- 图标：时钟+对勾（有效时长） -->
            <svg viewBox="0 0 48 48" width="44" height="44" aria-hidden="true">
              <circle cx="21" cy="24" r="14" fill="none" stroke="#1a4fa0" stroke-width="3"/>
              <path d="M21 16v8l6 4" fill="none" stroke="#1a4fa0" stroke-width="3" stroke-linecap="round"/>
              <circle cx="37" cy="14" r="8" fill="#2e9d5f"/>
              <path d="M33.5 14l2.5 2.5 4.5-4.5" fill="none" stroke="#fff" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="p-item-body">
            <div class="p-item-title">01 有效学习时长精确采集</div>
            <div class="p-item-desc">30 秒心跳 + 页面可见性检测 + 视频播放状态三重校验，只计"真在看"的时间，切后台、最小化一律不计，数据真实可审计。</div>
          </div>
        </div>
        <div class="p-item">
          <div class="p-icon">
            <!-- 图标：盾牌+对勾（防刷课） -->
            <svg viewBox="0 0 48 48" width="44" height="44" aria-hidden="true">
              <path d="M24 5l14 5v11c0 9.5-6 17.5-14 21-8-3.5-14-11.5-14-21V10l14-5z" fill="none" stroke="#1a4fa0" stroke-width="3" stroke-linejoin="round"/>
              <path d="M17 23l5 5 10-10" fill="none" stroke="#2e9d5f" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="p-item-body">
            <div class="p-item-title">02 智能防刷课体系</div>
            <div class="p-item-desc">5 分钟无交互自动暂停计时、随机弹窗验证、单会话防多开、视频进度单调递增去重——挂机、快进、多开刷时长，全部无效。</div>
          </div>
        </div>
        <div class="p-item">
          <div class="p-icon">
            <!-- 图标：作业纸+AI星光（智能批改） -->
            <svg viewBox="0 0 48 48" width="44" height="44" aria-hidden="true">
              <rect x="10" y="6" width="24" height="34" rx="3" fill="none" stroke="#1a4fa0" stroke-width="3"/>
              <path d="M16 15h12M16 22h12M16 29h7" stroke="#1a4fa0" stroke-width="2.6" stroke-linecap="round"/>
              <path d="M37 26l1.8 4.2 4.2 1.8-4.2 1.8L37 38l-1.8-4.2-4.2-1.8 4.2-1.8L37 26z" fill="#f0a02a"/>
            </svg>
          </div>
          <div class="p-item-body">
            <div class="p-item-title">03 AI 智能批改作业</div>
            <div class="p-item-desc">学生拍照上传，智能 Agent 逐题识别判分，自动生成批改报告与正确率统计；支持定时自动批改与一键重批，大幅减轻教师负担。</div>
          </div>
        </div>
        <div class="p-item">
          <div class="p-icon">
            <!-- 图标：日历+奖杯（签到与排行） -->
            <svg viewBox="0 0 48 48" width="44" height="44" aria-hidden="true">
              <rect x="7" y="10" width="24" height="22" rx="3" fill="none" stroke="#1a4fa0" stroke-width="3"/>
              <path d="M7 17h24" stroke="#1a4fa0" stroke-width="3"/>
              <path d="M13 25l4 4 8-9" fill="none" stroke="#2e9d5f" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M33 30c6 0 9-3 9-7 3 1 4 6 1 10h-8c-1 3-3 4-5 4h10" fill="none" stroke="#f0a02a" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="p-item-body">
            <div class="p-item-title">04 学习场景全覆盖</div>
            <div class="p-item-desc">课程小节、月度签到日历、学习排行榜、小节评价、分级公告、个人/班级/全平台学习报告，一个平台承载完整学习闭环。</div>
          </div>
        </div>
        <div class="p-item">
          <div class="p-icon">
            <!-- 图标：柱状图+消息推送（数据督导） -->
            <svg viewBox="0 0 48 48" width="44" height="44" aria-hidden="true">
              <path d="M8 40h32" stroke="#1a4fa0" stroke-width="3" stroke-linecap="round"/>
              <rect x="11" y="26" width="6" height="14" rx="1.5" fill="#4a7bd0"/>
              <rect x="21" y="18" width="6" height="22" rx="1.5" fill="#1a4fa0"/>
              <rect x="31" y="30" width="6" height="10" rx="1.5" fill="#8fb3e6"/>
              <path d="M30 12c4 0 7 2 7 6s-2 6-2 8h-8c0-2-2-4-2-8s3-6 5-6z" fill="none" stroke="#f0a02a" stroke-width="2.6" stroke-linejoin="round"/>
              <path d="M29 12a3 3 0 016 0" fill="none" stroke="#f0a02a" stroke-width="2.2"/>
            </svg>
          </div>
          <div class="p-item-body">
            <div class="p-item-title">05 数据督导闭环</div>
            <div class="p-item-desc">教师看板可视化统计 + 每日数据 + 未完成名单，学习提醒与每日报告定时推送钉钉群，Excel 一键导出，家校沟通有据可依。</div>
          </div>
        </div>

        <div class="p-quote">"让每一分钟学习都被看见，让每一份努力都真实可信。"</div>
      </div>

      <!-- 右侧：通栏主视觉——模糊校园背景 + 文字叠加层（与整页等高） -->
      <div class="promo-right">
        <svg class="p-campus" viewBox="0 0 420 900" preserveAspectRatio="xMidYMid slice" aria-hidden="true">
          <defs>
            <linearGradient id="skyGrad" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0" stop-color="#bfe0ff"/>
              <stop offset="0.55" stop-color="#dff0ff"/>
              <stop offset="1" stop-color="#eaf6ea"/>
            </linearGradient>
            <filter id="campusBlur" x="-10%" y="-10%" width="120%" height="120%">
              <feGaussianBlur stdDeviation="7"/>
            </filter>
          </defs>

          <!-- 天空底色（不模糊） -->
          <rect x="0" y="0" width="420" height="900" fill="url(#skyGrad)"/>

          <!-- 校园场景（整体高斯模糊） -->
          <g filter="url(#campusBlur)">
            <!-- 太阳光晕与云 -->
            <circle cx="330" cy="90" r="52" fill="#fff6d8"/>
            <ellipse cx="110" cy="130" rx="70" ry="20" fill="#ffffff" opacity="0.9"/>
            <ellipse cx="250" cy="180" rx="55" ry="16" fill="#ffffff" opacity="0.8"/>

            <!-- 远处主教学楼 -->
            <rect x="120" y="300" width="180" height="220" rx="4" fill="#5b8fd6"/>
            <rect x="196" y="252" width="28" height="52" fill="#4a7bd0"/>
            <path d="M120 300L210 240l90 60z" fill="#3c6cb8"/>
            <!-- 教学楼窗格 -->
            <g fill="#dcecff">
              <rect x="138" y="326" width="26" height="30"/><rect x="178" y="326" width="26" height="30"/><rect x="218" y="326" width="26" height="30"/><rect x="258" y="326" width="26" height="30"/>
              <rect x="138" y="376" width="26" height="30"/><rect x="178" y="376" width="26" height="30"/><rect x="218" y="376" width="26" height="30"/><rect x="258" y="376" width="26" height="30"/>
              <rect x="138" y="426" width="26" height="30"/><rect x="178" y="426" width="26" height="30"/><rect x="218" y="426" width="26" height="30"/><rect x="258" y="426" width="26" height="30"/>
            </g>
            <rect x="192" y="466" width="36" height="54" rx="3" fill="#2f5a9e"/>

            <!-- 左侧实验楼 -->
            <rect x="26" y="380" width="86" height="140" rx="4" fill="#7fa7dd"/>
            <g fill="#eaf2fc">
              <rect x="40" y="400" width="20" height="22"/><rect x="76" y="400" width="20" height="22"/>
              <rect x="40" y="440" width="20" height="22"/><rect x="76" y="440" width="20" height="22"/>
            </g>
            <!-- 右侧图书馆 -->
            <rect x="312" y="360" width="92" height="160" rx="4" fill="#6a99d4"/>
            <g fill="#e2eeff">
              <rect x="326" y="382" width="20" height="26"/><rect x="366" y="382" width="20" height="26"/>
              <rect x="326" y="428" width="20" height="26"/><rect x="366" y="428" width="20" height="26"/>
            </g>

            <!-- 旗杆 -->
            <rect x="208" y="520" width="4" height="80" fill="#8a8f98"/>
            <path d="M212 520h30l-8 9 8 9h-30z" fill="#e0574f"/>

            <!-- 草坪与步道 -->
            <rect x="0" y="520" width="420" height="380" fill="#9fd08a"/>
            <path d="M170 900L196 520h28l34 380z" fill="#e8dcb8"/>

            <!-- 树木 -->
            <g>
              <circle cx="70" cy="560" r="34" fill="#5aa64f"/><rect x="64" y="580" width="12" height="34" fill="#8a6242"/>
              <circle cx="352" cy="574" r="38" fill="#4f9a48"/><rect x="346" y="600" width="12" height="36" fill="#8a6242"/>
              <circle cx="110" cy="660" r="26" fill="#6cb45c"/><rect x="105" y="676" width="10" height="26" fill="#8a6242"/>
              <circle cx="304" cy="680" r="28" fill="#5aa64f"/><rect x="299" y="698" width="10" height="28" fill="#8a6242"/>
            </g>

            <!-- 操场跑道一角 -->
            <ellipse cx="210" cy="810" rx="180" ry="66" fill="#e2886b"/>
            <ellipse cx="210" cy="810" rx="140" ry="46" fill="#9fd08a"/>
          </g>

          <!-- 蒙层：提亮文字可读性 -->
          <rect x="0" y="0" width="420" height="900" fill="#1a4fa0" opacity="0.28"/>
        </svg>

        <!-- 文字叠加层 -->
        <div class="p-overlay">
          <div class="p-ov-badge">AI 赋能教育</div>
          <div class="p-ov-title">智慧学习</div>
          <div class="p-ov-title2">在线学习过程监督平台</div>
          <div class="p-ov-line"></div>
          <div class="p-ov-slogan">观看 · 督导 · 反馈 · 激励</div>
          <div class="p-ov-foot">有效时长采集 · 智能防刷课 · AI 作业批改 · 数据督导闭环</div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* 页面整体：浅色渐变底，与宣传图风格统一 */
.promo-page {
  min-height: 100vh;
  background: linear-gradient(160deg, #eaf2fc 0%, #f4f8fd 40%, #e8f1fb 100%);
  padding: 24px 16px;
  box-sizing: border-box;
}

.promo-card {
  max-width: 1080px;
  margin: 0 auto;
  background: #f4f8fd;
  border-radius: 14px;
  box-shadow: 0 4px 24px rgba(26, 79, 160, 0.12);
  padding: 28px;
  display: flex;
  gap: 24px;
  align-items: stretch;
}

.promo-left {
  flex: 1.2;
  min-width: 0;
}

/* 右侧主视觉：与整页等高（relative 为内部绝对定位的 SVG/文字层提供定位上下文） */
.promo-right {
  position: relative;
  flex: 1;
  min-width: 0;
  align-self: stretch;
  min-height: 520px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 18px rgba(26, 79, 160, 0.25);
}

.p-campus {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  display: block;
}

/* 文字叠加层 */
.p-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: #fff;
  padding: 24px;
  box-sizing: border-box;
}
.p-ov-badge {
  font-size: 13px;
  letter-spacing: 4px;
  border: 1px solid rgba(255, 255, 255, 0.75);
  border-radius: 999px;
  padding: 5px 18px;
  margin-bottom: 22px;
  background: rgba(26, 79, 160, 0.25);
}
.p-ov-title {
  font-size: 44px;
  font-weight: 800;
  letter-spacing: 8px;
  text-shadow: 0 3px 12px rgba(15, 45, 95, 0.55);
}
.p-ov-title2 {
  font-size: 19px;
  font-weight: 600;
  letter-spacing: 5px;
  margin-top: 14px;
  text-shadow: 0 2px 8px rgba(15, 45, 95, 0.5);
}
.p-ov-line {
  width: 64px;
  height: 3px;
  background: #ffffff;
  border-radius: 2px;
  opacity: 0.9;
  margin: 24px 0;
}
.p-ov-slogan {
  font-size: 15px;
  letter-spacing: 6px;
  text-shadow: 0 2px 6px rgba(15, 45, 95, 0.5);
}
.p-ov-foot {
  position: absolute;
  bottom: 22px;
  left: 0;
  right: 0;
  font-size: 12px;
  letter-spacing: 2px;
  opacity: 0.92;
  text-shadow: 0 1px 4px rgba(15, 45, 95, 0.6);
}

/* 左侧文字排版 */
.p-title {
  text-align: center;
  font-size: 26px;
  color: #1a4fa0;
  margin: 0 0 10px;
}
.p-slogan {
  text-align: center;
  color: #4a7bd0;
  font-size: 14px;
  letter-spacing: 3px;
  margin-bottom: 18px;
}
.p-para {
  font-size: 13px;
  color: #444;
  line-height: 1.9;
  text-align: justify;
  margin: 0 0 12px;
}
.p-subtitle {
  text-align: center;
  font-size: 19px;
  color: #1a4fa0;
  margin: 20px 0 14px;
}

.p-item {
  display: flex;
  align-items: center;
  gap: 12px;
  background: #fff;
  border: 1px solid #dce8f7;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 12px;
}
.p-icon {
  width: 64px;
  height: 64px;
  border-radius: 8px;
  background: linear-gradient(150deg, #eef4fb, #dbe9f9);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.p-item-body { min-width: 0; }
.p-item-title {
  font-size: 14px;
  font-weight: 700;
  color: #1a4fa0;
  margin-bottom: 4px;
}
.p-item-desc {
  font-size: 12.5px;
  color: #666;
  line-height: 1.7;
}

.p-quote {
  text-align: center;
  font-size: 12.5px;
  color: #4a7bd0;
  margin-top: 18px;
}

/* 窄屏（手机/钉钉）：上下布局，主视觉置顶 */
@media (max-width: 720px) {
  .promo-card { flex-direction: column; padding: 18px; }
  .promo-right { order: -1; min-height: 340px; }
  .p-ov-title { font-size: 30px; letter-spacing: 5px; }
  .p-ov-title2 { font-size: 15px; letter-spacing: 3px; }
  .p-ov-slogan { font-size: 13px; letter-spacing: 4px; }
  .p-ov-foot { font-size: 10.5px; letter-spacing: 1px; }
  .p-title { font-size: 21px; }
  .p-icon { width: 52px; height: 52px; }
  .p-icon svg { width: 36px; height: 36px; }
}
</style>
