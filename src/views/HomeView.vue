<script setup lang="ts">
import {ref} from 'vue'

const age = ref<number>(31);
</script>

<template>
  <section>
    <div class="color"></div>
    <div class="color"></div>
    <div class="color"></div>
    <div class="box">
      <div class="container">
        <div class="head">
          <img src="../assets/images/head.jpg" class="header" />
          <div class="status">
            <div class="subtitle">
              <p>本科</p>
              <p>在职</p>
              <p>苏州</p>
              <p>{{ age }}</p>
            </div>
          </div>
        </div>
        <h2>孟虎</h2>
        <p class="description">前端工程师,手机号<em>13151634514</em></p>

        <ul class="contactWay">
          <li><a href="blog/"><img src="../assets/images/blog.png" alt="blog">
              <p>博客</p>
            </a></li>
          <li class="wechat"><img src="../assets/images/wechat_logo.png" alt="homepage">
            <p>微信</p>
            <img src="../assets/images/wechat.png" alt="" id="wechatQR">
          </li>
          <li> <a href="https://github.com/menghu1994"><img src="../assets/images/github.png" alt="github">
              <p>github</p>
            </a></li>
          <li><a href="#" onclick="copy()"><img src="../assets/images/gmail.png" title="meng1037127772@gmail.com" alt="gmail">
              <p>Gmail</p>
              </a>
          </li>
        </ul>
        <input type="text" id="gmailLink" value="meng1037127772@gmail.com" style="position: fixed;left:-2400px">
      </div>
      <div class="square" style="--i:0;"></div>
      <div class="square" style="--i:1;"></div>
      <div class="square" style="--i:2;"></div>
      <div class="square" style="--i:3;"></div>
      <div class="square" style="--i:4;"></div>
    </div>
    <!-- <div class="weddingDays">
      <span>我们已经在一起:</span>
      <span><span id="day">00</span>天</span>
      <strong><span id="hour">00</span>时</strong>
      <strong><span id="minute">00</span>分</strong>
      <strong><span id="second">00</span>秒</strong>
    </div> -->
  </section>
</template>

<style scoped>
@import url("https://fonts.google.com/specimen/Poppins?selection.family=Open+Sans|Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900");

body,
section,
ul,
li,
img,
a,
p,
h2 {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: "Poppins", sans-serif;
}

ul,
li {
  list-style: none;
}

a {
  text-decoration: none;
  color: #fff;
}

section {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  background: linear-gradient(to bottom, #f1f4f9, #dff1ff);
}

section .color {
  position: absolute;
  filter: blur(150px);
}

section .color:nth-child(1) {
  top: -350px;
  right: -100px;
  width: 600px;
  height: 600px;
  background: #F28DA8;
}

section .color:nth-child(2) {
  bottom: -150px;
  left: 100px;
  width: 500px;
  height: 500px;
  background: #ace0f9;
}

section .color:nth-child(3) {
  bottom: 50px;
  left: 100px;
  width: 300px;
  height: 300px;
  background: #D8D9D0;
}

.box {
  position: relative;
}

.box .square {
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

.box .square:nth-child(1) {
  top: -50px;
  right: -60px;
  width: 100px;
  height: 100px;
}

.box .square:nth-child(2) {
  top: 10px;
  left: -100px;
  width: 120px;
  height: 120px;
  z-index: 2;
}

.box .square:nth-child(3) {
  top: 50px;
  right: -60px;
  width: 80px;
  height: 80px;
}

.box .square:nth-child(4) {
  bottom: -80px;
  left: 100px;
  width: 50px;
  height: 50px;
}

.box .square:nth-child(5) {
  bottom: -80px;
  left: 140px;
  width: 60px;
  height: 60px;
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
}

.container h2 {
  font-size: 1.5em;
  font-weight: 600;
  letter-spacing: 1px;
  color: #333;
  line-height: 1.5em;
}

.container p {
  font-size: 1em;
  font-weight: 600;
  letter-spacing: 1px;
}

.container .description {
  font-size: 1.3em;
  margin: 20px;
}

.container .head {
  position: relative;
}

.container .head .header {
  width: 80px;
  height: 80px;
  border: 3px solid white;
  border-radius: 50%;
  padding: 2px;
}

.container .status {
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
}

.container .status .subtitle {
  width: 100%;
  position: absolute;
  text-align: center;
  animation: moveup 8s 1s infinite;
}

.subtitle p {
  background: linear-gradient(to right, red, blue);
  color: transparent;
  -webkit-background-clip: text;

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
  display: flex
}

.contactWay li {
  text-align: center;
}

.contactWay li img {
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


.contactWay .wechat {
  position: relative;
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

.weddingDays {
  font-size: 28px;
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  background: linear-gradient(to right, red, blue);
  -webkit-background-clip: text;
  color: transparent;
}</style>
