$(function(){
  window.filter = new FILTERAPP.Filter();
  filter.init('.m_filter_form','.m_filter_content','#m_filter_template');
  

  
  
  //console.log(filter.init('ivan'));
  // var form = $('.m_filter'),
  //     formUrl= form.attr('action');

  // form.on('change',function(e){
  //   e.preventDefault();

  //   var request = $.ajax({
  //     url: formUrl,
  //     data: form.serialize(),
  //     type: form.attr('method') || 'get'
      
  //   })
  //   request.done(function(data){
  //     console.log(data.results)
  //   });
    
  //   request.fail(function(){
  //     console.log('error');
  //   })

  // });
});