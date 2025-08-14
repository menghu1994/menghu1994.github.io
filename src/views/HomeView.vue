<script setup lang="ts">
import { computed, ref } from 'vue'
import application from '@/components/application.vue'

const userInfo = ref({
  name: '孟虎',
  sex: '男',
  phone: '13151634514',
  email: 'meng1037127772@gmail.com',
  education: '本科',
  job: '前端工程师',
  status: '在职',
  location: '苏州',
  blog: 'https://blog.mengyunyi.top',
  github: 'https://github.com/menghu1994'
})

const age = computed(() => {
  return new Date().getFullYear() - 1994
})

const curYear = new Date().getFullYear();


function copyTextToClipboard(text: string) {
  try {
    if (navigator?.clipboard?.writeText) {
      navigator.clipboard.writeText(text);
      alert('复制成功');
    } else {
      console.warn('Clipboard API not supported by this browser.');
    }
  } catch (err) {
    console.error('Failed to copy text: ', err);
  }
}

const copy = () => {
  copyTextToClipboard(userInfo.value.email)
}
</script>

<template>
  <div class="interview">
    <div class="color"></div>
    <div class="color"></div>
    <div class="color"></div>
    <div class="box">
      <div class="container">
        <div class="head">
          <img src="../assets/images/head.jpg" class="header" />
          <div class="status">
            <div class="subtitle">
              <p>{{ userInfo.education }}</p>
              <p>{{ userInfo.location }}</p>
              <p>{{ age }}</p>
              <p>{{ userInfo.status }}</p>
            </div>
          </div>
        </div>
        <h2>{{ userInfo.name }}</h2>
        <p class="description">{{ userInfo.job }}<br />Call Me: <a :href="'tel:' + userInfo.phone"><em>{{ userInfo.phone
        }}</em></a></p>

        <ul class="contactWay">
          <li>
            <a href="blog/"><img src="../assets/images/blog.png" alt="blog">
              <p>博客</p>
            </a>
          </li>
          <li class="wechat">
            <img src="../assets/images/wechat_logo.png" alt="homepage">
            <p>微信</p>
            <img src="../assets/images/wechat.png" alt="" id="wechatQR">
          </li>
          <li>
            <a href="https://github.com/menghu1994">
              <img src="../assets/images/github.png" alt="github">
              <p>github</p>
            </a>
          </li>
          <li>
            <a href="#" @click.prevent="copy()"><img src="../assets/images/gmail.png" :title="userInfo.email"
                alt="gmail">
              <p>Gmail</p>
            </a>
          </li>
        </ul>
      </div>
      <div class="square" style="--i:0;"></div>
      <div class="square" style="--i:1;"></div>
      <div class="square" style="--i:2;"></div>
      <div class="square" style="--i:3;"></div>
      <div class="square" style="--i:4;"></div>
    </div>
    <div class="apps">
      <application></application>
    </div>
    <!-- <div class="weddingDays">
      <span>我们已经在一起:</span>
      <span><span id="day">00</span>天</span>
      <strong><span id="hour">00</span>时</strong>
      <strong><span id="minute">00</span>分</strong>
      <strong><span id="second">00</span>秒</strong>
    </div> -->
    <div class="footer-copyright text-center">Copyright ©
      <a href="https://www.mengyunyi.top/"> MENGYUNYI.TOP</a> {{ curYear }} 备案号：<a target="_blank" rel="nofollow"
        href="https://beian.miit.gov.cn/">苏ICP备2024150994号-2</a>
    </div>
  </div>
</template>

<style scoped lang="scss">
.interview {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(to bottom, #f1f4f9, #dff1ff);
  overflow-y: auto;

  .color {
    position: absolute;
    filter: blur(150px);

    &:nth-child(1) {
      top: -350px;
      right: -100px;
      width: 600px;
      height: 600px;
      background: #F28DA8;
    }

    &:nth-child(2) {
      bottom: -150px;
      left: 100px;
      width: 500px;
      height: 500px;
      background: #ace0f9;
    }

    &:nth-child(3) {
      bottom: 50px;
      left: 100px;
      width: 300px;
      height: 300px;
      background: #D8D9D0;
    }
  }
}


.box {
  position: relative;

  .square {
    position: absolute;
    backdrop-filter: blur(5px);
    box-shadow: 0 25px 45px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-right: 1px solid rgba(255, 255, 255, 0.2);
    border-bottom: 1px solid rgba(255, 255, 255, 0.2);
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
    animation: animate 10s linear infinite;
    animation-delay: calc(-1s * var(--i));

    &:nth-child(1) {
      top: -50px;
      right: -60px;
      width: 100px;
      height: 100px;
    }

    &:nth-child(2) {
      top: 10px;
      left: -100px;
      width: 120px;
      height: 120px;
      z-index: 2;
    }

    &:nth-child(3) {
      top: 50px;
      right: -60px;
      width: 80px;
      height: 80px;
    }

    &:nth-child(4) {
      bottom: -80px;
      left: 100px;
      width: 50px;
      height: 50px;
    }

    &:nth-child(5) {
      bottom: -80px;
      left: 140px;
      width: 60px;
      height: 60px;
    }

    &:nth-child(6) {
      bottom: -180px;
      left: 240px;
      width: 60px;
      height: 60px;
    }
  }
}

@keyframes animate {

  0%,
  100% {
    transform: translateY(-40px);
  }

  50% {
    transform: translateY(40px);
  }
}

.apps {
  width: 700px;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 2rem;
  z-index: 1;
}

.container {
  color: #fff;
  position: relative;
  width: 700px;
  min-height: 300px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  backdrop-filter: blur(5px);
  box-shadow: 0 25px 45px rgba(0, 0, 0, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-right: 1px solid rgba(255, 255, 255, 0.2);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  padding: 30px;
  margin-bottom: 2rem;

  h2 {
    font-size: 1.5em;
    font-weight: 600;
    letter-spacing: 1px;
    color: #333;
    line-height: 1.5em;
  }

  p {
    font-size: 1em;
    font-weight: 600;
    letter-spacing: 1px;
  }

  .description {
    font-size: 1.3em;
    margin: 20px;
    text-align: center;
    color: transparent;
    background: -webkit-linear-gradient(to right, #fa2c05, #f637e3);
    background-image: linear-gradient(90deg, #fa2c05 0%, #f637e3 50%, #8514f5 100%);
    background-clip: text;
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;

    a {
      text-decoration: underline;
      text-decoration-color: red;
    }
  }

  .head {
    position: relative;

    .header {
      width: 80px;
      height: 80px;
      border: 3px solid white;
      border-radius: 50%;
      padding: 2px;
    }
  }

  .status {
    position: absolute;
    top: 18px;
    right: -80px;
    width: 70px;
    height: 50px;
    line-height: 50px;
    box-shadow: 0 25px 45px rgb(0 0 0 / 10%);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 10px;
    animation: pulse 2s linear infinite;
    overflow: hidden;

    .subtitle {
      width: 100%;
      position: absolute;
      text-align: center;
      animation: moveup 8s 1s infinite;

      p {
        background: linear-gradient(to right, red, blue);
        color: transparent;
        -webkit-background-clip: text;

      }
    }
  }

}


@keyframes pulse {
  50% {
    transform: scale(1.1);
  }
}

@keyframes moveup {
  0% {
    top: 0px;
  }

  33% {
    top: -50px;
  }

  66% {
    top: -100px;
  }

  100% {
    top: -150px;
  }

}

.contactWay {
  padding: 10px;
  display: flex;

  li {
    text-align: center;

    img {
      width: 3.4em;
      height: 3.4em;
      background: rgba(255, 255, 255, 0.2);
      padding: 6px;
      border-radius: 10px;
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-right: 1px solid rgba(255, 255, 255, 0.2);
      border-bottom: 1px solid rgba(255, 255, 255, 0.2);
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
      margin: 0 15px;
      text-align: center;
    }

    p {
      color: #525252;
      font-size: 12px;
    }
  }

  .wechat {
    position: relative;
  }
}

#wechatQR {
  position: absolute;
  top: 65px;
  left: 0;
  width: 150px;
  height: 150px;
  display: none;
}

.contactWay .wechat:hover #wechatQR {
  display: block;
}

.contactWay .wechat:active #wechatQR {
  display: block;
}

.weddingDays {
  font-size: 28px;
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  background: linear-gradient(to right, red, blue);
  -webkit-background-clip: text;
  color: transparent;
}

.footer-copyright {
  position: absolute;
  bottom: 0.5rem;
  text-align: center;
  word-wrap: normal;
  font-size: 0.8rem;
  color: rgba($color: #000000, $alpha: 0.6);

  a {
    color: inherit;

    &:hover {
      text-decoration: underline;
    }
  }
}

@media screen and (max-width: 767px) {
  .interview {
    width: 100vw;
    overflow-x: hidden;
  }

  .box {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .container {
    width: 90%;
  }

  .box .square {
    animation: animate 7s linear infinite;

    &:nth-child(1) {
      top: -50px;
      right: -60px;
      width: 100px;
      height: 100px;
    }

    &:nth-child(2) {
      top: 15%;
      left: 3%;
      width: 100px;
      height: 100px;
      z-index: 2;
    }

    &:nth-child(3) {
      top: -30px;
      right: 0px;
      width: 80px;
      height: 80px;
    }

    &:nth-child(4) {
      bottom: 22%;
      left: 10%;
      width: 50px;
      height: 50px;
      display: none;
    }

    &:nth-child(5) {
      bottom: 15%;
      left: 30%;
      width: 60px;
      height: 60px;
      display: none;
    }

    &:nth-child(6) {
      bottom: 130px;
      right: 0;
      width: 40px;
      height: 40px;
      display: none;
    }
  }

  .footer-copyright {
    width: 100%;
  }

}
</style>
