const app = Vue.createApp({
  // data is a function. it returns the data
  data: function () {
    return {
      word: "awe",
      meanings: [
        "v. (passive, formal) sb is awed by 敬畏的",
        "n. very impressed by sth/sb. 敬畏",
      ],
      examples: [
        "He speaks of her with awe.",
        "他谈到她时肃然起敬。",
        "It's magnificent. She whispered in awe.",
        "真是壮观。她小声惊叹道。",
        "She seemed awed by what she had seen.",
        "她被眼前的一切惊叹不已。",
      ],
      imgs: [
        "https://www.healthyplace.com/sites/default/files/2018-11/being-in-awe.jpg",
      ],
      speaking: ""
    };
  },
  methods: {
    speak(m) {
      this.speaking = m
      setInterval(()=>{
        this.speaking = ''
      }, 3000)
    }
  }
}).mount("#app");
