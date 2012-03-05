$(document).ready(function() {
	var showresults;

	$('#find_shows').bind("ajax:success", function(evt, data, status, xhr) {
		$('#find_results').show();
		showresults = data;
		for(i = 0; i < data.length; i++) {
			var aired = (data[i].aired) ? ' (First Aired: ' + data[i].aired + ')' : '';
			var item = "<a href='#" + i + "'>" + data[i].name + aired + "</a>";
			$('#show_list').append('<li>' + item + '</li>');
		}
	});

	$(document).on("click", "#show_list a", function(event) {
		event.preventDefault();
		var resultid = event.target.hash.replace("#", '');
		var selected = showresults[resultid];
		$("#add_show input#show_title").val(selected.name);
		$("#add_show input#show_description").val(selected.overview);
		$("#add_show input#show_tvdb_id").val(selected.id);
		$("#add_show").submit();
	});
});