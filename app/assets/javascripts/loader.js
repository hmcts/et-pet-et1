$(document).ready(function(){
  $('textarea[maxlength]').each(function(i, area){
    countable.init(area);
  });
});
