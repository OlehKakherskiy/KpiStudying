var str = "b+d+b-d-d-b+d+d+d-b+";

 result = str.match(/([bd][+-]){1,}/g);

if(result[0].length < str.length)
	console.log("слово не выводится с грамматики")
else console.log("слово выводится с правил грамматики")