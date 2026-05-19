<script lang="ts" setup>
import { computed, onMounted, onUnmounted, ref } from 'vue';

interface Application {
  name: string;
  link: string;
  desc: string;
  stack?: string[];
  accent: string;
}

const applications: Application[] = [
  {
    name: '后台管理',
    link: 'https://matero.mengyunyi.top',
    desc: '后台管理平台, 已接入ai对话',
    stack: ['Angular', 'Angular Material', 'Nestjs', 'Mongo'],
    accent: '#3b82f6',
  },
  {
    name: '工具集',
    link: 'https://tool.mengyunyi.top',
    desc: '常用在线工具集合, Extend Fork Project',
    stack: ['Vue3', 'naive-ui'],
    accent: '#3b82f6',
  },
  {
    name: '大屏设计器',
    link: 'https://screen.mengyunyi.top',
    desc: '可视化大屏编辑器, Fork Project',
    stack: ['Vue3'],
    accent: '#8b5cf6',
  },
  {
    name: '视频作品展示网站',
    link: 'https://jianwei.mengyunyi.top',
    desc: '项目与设计作品展示',
    stack: ['Angular', 'Nestjs'],
    accent: '#f97316',
  },
];

const isPhone = ref(false);
const iconErrorMap = ref<Record<string, boolean>>({});

const displayApplications = computed(() =>
  isPhone.value ? [...applications, ...applications] : applications,
);

const animationDuration = computed(() =>
  `${Math.max(applications.length * 4, 12)}s`,
);

const updateViewport = () => {
  isPhone.value = window.innerWidth <= 768;
};

const getFaviconUrl = (link: string) => {
  try {
    return `${new URL(link).origin}/favicon.ico`;
  } catch {
    return '';
  }
};

const getInitial = (name: string) => name.trim().charAt(0).toUpperCase();

const handleImageError = (link: string) => {
  iconErrorMap.value = {
    ...iconErrorMap.value,
    [link]: true,
  };
};

onMounted(() => {
  updateViewport();
  window.addEventListener('resize', updateViewport);
});

onUnmounted(() => {
  window.removeEventListener('resize', updateViewport);
});
</script>

<template>
  <div v-if="applications.length" class="scroll-wrapper">
    <div class="app-container" :data-animate="isPhone" :style="{ animationDuration }">
      <a v-for="(app, index) in displayApplications" :key="`${app.link}-${index}`" class="app-item" :href="app.link"
        target="_blank" rel="noopener noreferrer" :style="{ '--app-accent': app.accent }">
        <div class="app-logo-wrap">
          <img v-if="getFaviconUrl(app.link) && !iconErrorMap[app.link]" class="app-logo" loading="lazy"
            :src="getFaviconUrl(app.link)" :alt="`${app.name} logo`" width="44" height="44"
            @error="handleImageError(app.link)" />
          <div v-else class="app-logo fallback-logo" aria-hidden="true">
            {{ getInitial(app.name) }}
          </div>
        </div>

        <div class="app-content">
          <h3 class="app-header">{{ app.name }}</h3>
          <p class="app-desc">{{ app.desc }}</p>
        </div>
      </a>
    </div>
  </div>
</template>

<style lang="scss" scoped>
@keyframes scroll-left {
  from {
    transform: translateX(0);
  }

  to {
    transform: translateX(-50%);
  }
}

.scroll-wrapper {
  width: 100%;
  overflow: hidden;
}

.app-container {
  display: flex;
  gap: 1rem;
  width: max-content;
  will-change: transform;

  &[data-animate='true'] {
    animation: scroll-left linear infinite;
  }

  &:hover {
    animation-play-state: paused;
  }
}

.app-item {
  display: flex;
  align-items: center;
  gap: 0.875rem;
  min-width: 13.5rem;
  max-width: 14rem;
  padding: 1rem 1.1rem;
  color: #374151;
  text-decoration: none;
  border-radius: 8px;
  border: 1px solid rgba(255, 255, 255, 0.45);
  background: rgba(255, 255, 255, 0.55);
  backdrop-filter: blur(10px);
  box-shadow: 0 16px 32px rgba(15, 23, 42, 0.08);
  transition:
    transform 0.2s ease,
    box-shadow 0.2s ease,
    border-color 0.2s ease;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 20px 36px rgba(15, 23, 42, 0.12);
    border-color: color-mix(in srgb, var(--app-accent) 30%, white);
  }
}

.app-logo-wrap {
  flex: 0 0 auto;
}

.app-logo {
  display: grid;
  place-items: center;
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: #fff;
  border: 1px solid rgba(148, 163, 184, 0.25);
  box-shadow: 0 6px 18px rgba(15, 23, 42, 0.08);
  object-fit: cover;
}

.fallback-logo {
  color: var(--app-accent);
  font-size: 1rem;
  font-weight: 700;
  background: color-mix(in srgb, var(--app-accent) 14%, white);
}

.app-content {
  min-width: 0;
}

.app-header {
  margin: 0 0 0.25rem;
  color: #111827;
  font-size: 0.95rem;
  font-weight: 600;
  line-height: 1.2;
}

.app-desc {
  margin: 0;
  color: #6b7280;
  font-size: 0.8rem;
  line-height: 1.4;
  white-space: normal;
}

@media screen and (max-width: 767px) {
  .app-item {
    min-width: 12rem;
  }
}
</style>
