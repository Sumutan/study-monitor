<!--
  @模块：PsyPromo.vue — AI心理安全服务宣传页（独立页面，通过链接访问）
  @页面用途：以 URL 直接访问的宣传页（无需登录）。左侧为宣传文字（AI无感校园心理
            安全服务介绍），右侧为校园AI插画，布局参考宣传效果图（1.png）。
  @访问路径：/#/psy-promo（hash路由，公开页面，无角色限制）
  @数据流：纯静态展示页面，无后端交互。
  @依赖：assets/promo/ 下 5 张图片（1张插画 + 4张产品小截图）
-->
<template>
  <div class="promo-page">
    <div class="promo-card">
      <!-- 左侧：宣传文字 -->
      <div class="promo-left">
        <h1 class="p-title">AI 预防 智慧守护</h1>
        <div class="p-slogan">感知 · 预警 · 跟踪 · 关怀</div>

        <p class="p-para">
          中国电信 AI 无感校园心理健康服务，依托自有"云网数智安"底座，联合该信科技 AI
          视觉算法，充分复用学校已有监控设备，零改造、低成本，构建主动式心理安全防护体系。系统无感采集学生日常学习与活动中的情绪行为，形成"采集—研判—预警—干预"闭环，且数据不出校、权限可控，在保护隐私的前提下守护校园。
        </p>
        <p class="p-para">
          系统持续记录学生情绪行为变化，与自身过往表现及同群体特征做多维对比；当识别到情绪低落、压力升高、行为突变或异常反应时，结合持续时间、异常频次与波动幅度综合研判，自动生成分级预警，并推送班主任关注、心理教师访谈或专业评估，持续跟踪干预后变化，帮助老师更早发现"没被看见却正需要帮助"的学生，推动校园心理管理从经验判断走向数据驱动。目前已落地
          8 省市，杭州、温州、金华等试点成效显著。
        </p>

        <h2 class="p-subtitle">AI无感校园心理安全服务</h2>

        <div class="p-item">
          <img :src="shot1" class="p-shot" alt="无感式持续情绪感知" />
          <div class="p-item-body">
            <div class="p-item-title">01 无感式持续情绪感知</div>
            <div class="p-item-desc">依托校园现有安防监控网络，进行非接触式数据采集，无需学生佩戴任何设备，全程无感且保护隐私，实现校园全域覆盖。</div>
          </div>
        </div>
        <div class="p-item">
          <img :src="shot2" class="p-shot" alt="智能化风险预警" />
          <div class="p-item-body">
            <div class="p-item-title">02 智能化风险预警</div>
            <div class="p-item-desc">智能分析学生面部表情与活动规律，识别情绪风险与心理波动；实时生成多级预警，并通过平台通知、工作消息等渠道，即时推送至班主任与心理教师。</div>
          </div>
        </div>
        <div class="p-item">
          <img :src="shot3" class="p-shot" alt="AI 智能谈话助手" />
          <div class="p-item-body">
            <div class="p-item-title">03增值服务：AI 智能谈话助手</div>
            <div class="p-item-desc">基于潜在风险结果，自动生成针对性谈话提纲，并辅助班主任和心理教师快速生成标准化谈话报告，让心理辅导工作更精准、更高效。</div>
          </div>
        </div>
        <div class="p-item">
          <img :src="shot4" class="p-shot" alt="一生一档 闭环管理" />
          <div class="p-item-body">
            <div class="p-item-title">04 一生一档 闭环管理</div>
            <div class="p-item-desc">建立动态心理健康档案，持续监控学生情绪变化与干预记录，形成"筛查-预警-干预-追踪"的闭环管理体系。</div>
          </div>
        </div>

        <div class="p-quote">"科技赋能心理健康，让每一份心理风险都被看见，让每一次关怀都及时送达。"</div>
      </div>

      <!-- 右侧：校园AI插画（图内已含标题文字） -->
      <div class="promo-right">
        <img :src="campus" class="p-campus" alt="AI无感校园心理安全服务" />
      </div>
    </div>
  </div>
</template>

<script setup>
import campus from '../assets/promo/campus.png'
import shot1 from '../assets/promo/shot1.png'
import shot2 from '../assets/promo/shot2.png'
import shot3 from '../assets/promo/shot3.png'
import shot4 from '../assets/promo/shot4.png'
</script>

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
}

.promo-left {
  flex: 1.2;
  min-width: 0;
}

.promo-right {
  flex: 1;
  min-width: 0;
  position: sticky;
  top: 24px;
  align-self: flex-start;
}

.p-campus {
  width: 100%;
  border-radius: 10px;
  display: block;
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
  gap: 12px;
  background: #fff;
  border: 1px solid #dce8f7;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 12px;
}
.p-shot {
  width: 120px;
  height: 84px;
  object-fit: cover;
  border-radius: 6px;
  flex-shrink: 0;
  background: #eef4fb;
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

/* 窄屏（手机/钉钉）：上下布局，插画置顶 */
@media (max-width: 720px) {
  .promo-card { flex-direction: column; padding: 18px; }
  .promo-right { position: static; order: -1; }
  .p-title { font-size: 21px; }
  .p-shot { width: 96px; height: 68px; }
}
</style>
