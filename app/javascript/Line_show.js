console.log("✅ line_show.js 読み込み成功");
document.addEventListener('turbo:load', function () {
  const lineBtn = document.querySelector('.hare_line_button');
  if (!lineBtn) {
    console.warn("⚠️ ボタンが取得できませんでした！");
    return;
  }

  lineBtn.addEventListener('click', function () {
    console.log("✅ ボタンが押されました！");

    const rawUrl = lineBtn.dataset.url;
    if (!rawUrl || rawUrl.trim() === "") {
      alert("❌ LINEに送るURLが設定されていません！");
      return;
    }
    // 自分でペーストしなきゃいけない
    navigator.clipboard.writeText(rawUrl)
    .then(() => {
      alert("コピーしました");
  });
    //　友達を選択すると自動でURLはっつけ　共有機能みたいに？
    const lineShareUrl = "line://msg/text/" + encodeURIComponent(rawUrl);
    window.location.href = lineShareUrl;
  });
});