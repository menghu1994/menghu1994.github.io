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

const handleResize = () => {
  isPhone.value = window.innerWidth <= 768;
}

const handleScroll = () => {
  if (containerRef.value && containerRef.value.firstElementChild && isPhone.value) {
    const firstItem = containerRef.value.firstElementChild as HTMLElement;
    const gap = parseFloat(getComputedStyle(containerRef.value).gap) || 0;
    itemWidth.value = firstItem.offsetWidth + gap;
    itemCount.value = applications.value.length;
  } else {
    itemWidth.value = 0;
    itemCount.value = 0;
  }
}

onMounted(async () => {
  window.addEventListener("resize", handleResize);
  await nextTick();
  handleResize();
  handleScroll();
});

watchEffect(() => {
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener("resize", handleResize);
})
</script>

<template>
  <div class="scroll-wrapper" v-if="applications.length">
    <div class="app-container" ref="containerRef"
      :style="{ '--item-width': `${itemWidth}px`, '--item-count': itemCount }">
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
          <img class="app-logo" loading="lazy" :src="app.link + '/favicon.ico'" :alt="app.name" width="40" height="40" />
          <div class="app-content">
            <h3 class="app-header">{{ app.name }}</h3>
            <div class="app-desc">{{ app.desc }}</div>
          </div>
        </a>
      </template>
    </div>
  </div>
</template>

<style lang="scss">
@keyframes scroll-left {
  0% {
    transform: translateX(0);
  }

  100% {
    transform: translateX(calc(-1 * var(--item-width) * var(--item-count)));
  }
}
</style>

<style lang="scss" scoped>
.scroll-wrapper {
  width: 100%;
  position: relative;
  white-space: nowrap;
}

.app-container {
  display: inline-flex;
  gap: 1rem;
  animation: scroll-left linear infinite;
  animation-duration: calc(5s * var(--item-count));
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
