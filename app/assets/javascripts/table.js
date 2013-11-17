/*var state = {
	bag_size: 3,
	pool: "abcdef",
	stashes: {
		'leon': [[3, 'loel'], [1, 'guacamolee'], [2, 'heloe']]
	}
};

var onready = function() {
  for(var fiend in state.stashes) {
    state.stashes[fiend].sort(function(pair1, pair2) {
      return pair1[0] - pair2[0]
    });
  }
	updateAll(state);
};

var updateAll = function(state) {
	updateBag(state);
	updatePool(state);
	updateStashes(state);
};

var updateBag = function(state) {
	console.log("updating bag");
	var $bagBox = $('#bagBox');
	$bagBox.html(state.bag_size);
};

var updatePool = function(state) {
	console.log("updating pool");
	var $poolDiv = $('#poolDiv');
	$poolDiv.html('');
	var letters = state.pool;
	var i = 0;
	letters.split("").forEach(function(letter) {
		if (i%10==0){
			$poolDiv.append("<br>");
		}
		i++;
		$poolDiv.append('<img src="assets/tiles/' + letter + '.png"  width="40" height="40" hspace="1">');
	});
};

var updateStashes = function(state) {
	console.log("updating stashes");
	var stashes = state.stashes;
	for (var name in stashes) {
		var $stashDiv = findStashDivByName(name);
		$stashDiv.html('');

		stashes[name].forEach(function(entry) {
			$wordDiv = $("<div>").attr('turnNumber', entry[0]);
			entry[1].split('').forEach(function(letter) {
				$stashDiv.append('<img src="assets/tiles/' + letter + '.png"  width="40" height="40" hspace="1">');
			});
			$stashDiv.append($wordDiv);
		});

	}
};

var findStashDivByName = function(name) {
	return $("#stashDiv");
};

*/
// onready();
