<script lang="ts" setup>
import { ref, onMounted, nextTick, onUnmounted, watchEffect } from 'vue';

interface Application {
  name: string;
  logo: string;
  link: string;
  desc: string;
}

const applications = ref<Application[]>([
  { name: '工具集', logo: 'tool', link: 'http://129.204.224.75:38081', desc: '工具集' },
  { name: '大屏设计器', logo: 'tool', link: 'http://129.204.224.75:38080', desc: '大屏设计器' },
  { name: '作品设计展示', logo: 'tool', link: 'http://129.204.224.75:8090', desc: '作品设计展示' },
]);

const containerRef = ref<HTMLElement | null>(null);
const itemWidth = ref(0);
const itemCount = ref(0);
const isPhone = ref(false);

const animationDuration = ref(0);

const debounce = (fn: Function, delay = 100) => {
  let timer: number;
  return () => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(), delay) as unknown as number;
  };
};

const handleResize = () => {
  isPhone.value = window.innerWidth <= 768;
  if (isPhone.value) {
    calculateItemSize();
  }
}

const calculateItemSize = () => {
  if (containerRef.value && containerRef.value.firstElementChild) {
    const firstItem = containerRef.value.firstElementChild as HTMLElement;
    const gap = parseFloat(getComputedStyle(containerRef.value).gap) || 0;
    // 优化：强制获取布局后的尺寸（避免移动端尺寸为0）
    itemWidth.value = firstItem.getBoundingClientRect().width + gap;
    itemCount.value = applications.value.length;
    // 计算动画时长（5s * 数量）
    animationDuration.value = 5 * itemCount.value;
  } else {
    itemWidth.value = 0;
    itemCount.value = 0;
    animationDuration.value = 0;
  }
};

const handleScroll = () => {
  calculateItemSize();
}

onMounted(async () => {
  const handleTouchMove = (e: TouchEvent) => {
    if (isPhone.value) {
      e.preventDefault();
    }
  };
  window.addEventListener("resize", debounce(handleResize));
  window.addEventListener("touchmove", handleTouchMove, { passive: false });

  // 等待DOM完全渲染后再计算尺寸
  await nextTick();
  handleResize();
  // 优化：延迟计算（适配移动端DOM渲染延迟）
  setTimeout(calculateItemSize, 200)
});

watchEffect(() => {
  if (isPhone.value) {
    calculateItemSize();
  }
})

onUnmounted(() => {
  window.removeEventListener("resize", handleResize);
  window.removeEventListener("touchmove", (e) => e.preventDefault());
})
</script>

<template>
  <div class="scroll-wrapper" v-if="applications.length">
    <div class="app-container" ref="containerRef" v-bind="isPhone ? { 'data-animate': 'true' } : {}"
      :style="{ '--item-width': `${itemWidth}px`, '--item-count': itemCount, 'animation-duration': `${animationDuration}s` }">
      <!-- 原始内容 -->
      <a class="app-item" :href="app.link" target="_blank" v-for="app in applications" :key="app.name">
        <img class="app-logo" loading="lazy" :src="app.link + '/favicon.ico'" :alt="app.name" width="40" height="40" />
        <div class="app-content">
          <h3 class="app-header">{{ app.name }}</h3>
          <div class="app-desc">{{ app.desc }}</div>
        </div>
      </a>

      <!-- 克隆 -->
      <template v-if="isPhone">
        <a class="app-item" :href="app.link" target="_blank" v-for="app in applications" :key="'clone-' + app.name">
          <img class="app-logo" loading="lazy" :src="app.link + '/favicon.ico'" :alt="app.name" width="40"
            height="40" />
          <div class="app-content">
            <h3 class="app-header">{{ app.name }}</h3>
            <div class="app-desc">{{ app.desc }}</div>
          </div>
        </a>
      </template>
    </div>
  </div>
</template>

<style lang="scss" scoped>
@keyframes scroll-left {
  0% {
    transform: translateX(0);
  }

  100% {
    transform: translateX(-50%);
  }
}

.scroll-wrapper {
  width: 100%;
  position: relative;
  white-space: nowrap;
}

.app-container {
  display: inline-flex;
  gap: 1rem;
  animation: none;
  // 新增：硬件加速（解决移动端动画卡顿/不执行）
  transform: translateZ(0);
  will-change: transform;

  &[data-animate="true"] {
    animation: scroll-left linear infinite;
  }
}

a {
  color: #4b4b4b;
  text-decoration: none;
}

.app-item {
  position: relative;
  min-width: 12rem;
  font-size: 14px;
  border-radius: 0.5rem;
  padding: 1rem;
  backdrop-filter: blur(5px);
  box-shadow: 0 25px 45px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-right: 1px solid rgba(255, 255, 255, 0.2);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  flex-shrink: 0;

  .app-logo {
    position: absolute;
    left: 20px;
    margin-top: -2rem;
    z-index: 10;
    border-radius: 50%;
    border: 1px solid rgba(49, 49, 49, 0.4);
    padding: 4px;
    background: white;
  }

  .app-content {
    margin-top: 16px;

    .app-header {
      font-weight: bold;
      margin-bottom: 0.2rem;
    }

    .app-desc {
      color: #9b9b9b;
    }
  }
}
</style>
