// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery
import "@hotwired/turbo-rails"
import "controllers"
import jquery from "jquery"
window.$ = jquery

// トップページ、メイン画像
$(document).on('turbolinks:load',function () {
  $("#top-images").skippr({
    // スライドショーの変化 ("fade" or "slide")
    transition : 'fade',
    // 変化に係る時間(ミリ秒)
    speed : 2000,
    // easingの種類
    easing : 'easeOutQuart',
    // ナビゲーションの形("block" or "bubble")
    navType : 'bubble',
    // 子要素の種類('div' or 'img')
    childrenElementType : 'div',
    // ナビゲーション矢印の表示(trueで表示)
    arrows : false,
    // スライドショーの自動再生(falseで自動再生なし)
    autoPlay : true,
    // 自動再生時のスライド切替間隔(ミリ秒)
    autoPlayDuration : 3000,
    // キーボードの矢印キーによるスライド送りの設定(trueで有効)
    keyboardOnAlways : false,
    // 一枚目のスライド表示時に戻る矢印を表示するかどうか(falseで非表示)
    hidePrevious : false
  });

  $("#show-images").skippr({
    transition : 'fade',
    speed : 1000,
    easing : 'easeOutQuart',
    navType : 'bubble', 
    childrenElementType : 'div',
    arrows : true,
    autoPlay : false,
    autoPlayDuration : 7000,
    keyboardOnAlways : true,
    hidePrevious : true
  });
});

// // arrowアイコン
// $(document).on('turbolinks:load',function() {
//   $('#arrow a').on('click',function(event){
//     $('body, html').animate({
//       scrollTop:0
//     }, 800);
//     event.preventDefault();
//   });
// });

// ハンバーガーmenu
$(document).on('turbolinks:load',function() {
  $('.menu-trigger').on('click', function(event) {
    $(this).toggleClass('active');
    $('#sp-menu').fadeToggle();
    event.preventDefault();
  });
});