
function createBoard()
{
	var table = $("#board");
	for (var i = 0; i < 15; ++i)
	{
		var row = $("<tr/>");
		for (var j = 0; j < 15; ++j)
		{
			var cell = $("<td/>");
			if ((i+j) % 2 == 0)
				cell.addClass("even");
			else
				cell.addClass("odd");
			row.append(cell);
		}
		table.append(row);
	}
}

function initialise()
{
	createBoard();
	
	$("a#clear").click(function() { $("td").text(""); });
	$("a#test").click(function()
	{
		$.post("/board", { id : 500 }, function(data)
		{
			var table = document.getElementById("board");
			for (var i = 0, row; row = table.rows[i]; i++)
			{
				for (var j = 0, col; col = row.cells[j]; j++)
				{
					if (data[i][j] != null)
						$(col).text(data[i][j]);
					else
						$(col).text("");
				}
			}
		}, "json");
	});
}
