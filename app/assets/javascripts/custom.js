
$(document).ready(function(){

$('.add_meta_btn').on('click',function(e){

  e.preventDefault();
  e.stopPropagation();
  
  $this = $(e.target);
  $meta = $this.parent().find('.meta');

  i = $meta.length;

  // outer html hack
  html = '<div class="'+ $meta.attr('class') +'">'+ $meta.html() +'</div>';

  html = html.replace(/attributes_\d+_key/ig,'attributes_'+ i +'_key');
  html = html.replace(/\attributes\]\[\d+\]\[key\]/ig,'attributes]['+ i +'][key]');
 
  html = html.replace(/attributes_\d+_value/ig,'attributes_'+ i +'_value');
  html = html.replace(/\attributes\]\[\d+\]\[value\]/ig,'attributes]['+ i +'][value]'); 

  $this.parent().find('.meta-list').append(html);

  return false;
});


});
