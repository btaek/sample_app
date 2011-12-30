// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

	$(function() 
						{
					$("#micropost_content").live("keyup keydown", 
						function()
						{
							var left = 140 - $(this).val().length;
							$("#counter").html(left);
						});
				})