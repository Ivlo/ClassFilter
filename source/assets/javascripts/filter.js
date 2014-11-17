if (window.FILTERAPP  === undefined) window.FILTERAPP = {};
var Filter = function() {
  _.bindAll(this, "onFiltersChange","onStateChange");
};

Filter.prototype.init = function(element,contentData,template) {

  this.$element = $(element);
  this.$contentData = $(contentData);
  this.$template = _.template($(template).html());
  this.url = this.$element.attr('action');
  //this.status =false;
  this.bindEvents();
  this.getData();
},
Filter.prototype.bindEvents = function() {
  this.$element.on('change',this.onFiltersChange);
  $(window).on("popstate",this.onStateChange);
}
Filter.prototype.getData = function(e) {
  var self = this;

  var request = $.ajax({
    url: this.url,
    data: this.$element.serialize(),
    type: this.$element.attr('method') || 'get'
  })
  request.done(function(data){
    self.setData(data);
  });
  request.fail(function(){
    console.log('error');
  })

  return request;
}
Filter.prototype.onFiltersChange = function(){
  this.setUrl(); // Tendriamos que poner un spinner
  // this.startLoading(); // Pone el spinner
  this.getData()
    .done(function(){
      // this.finishedLoading(); // Te cargas el spinner
    });
}
Filter.prototype.setData = function(data) {
  this.$contentData.html(this.$template(data));  
}
Filter.prototype.setUrl = function() {
  this.new_url = this.$element.serialize();
  if (typeof window.history.pushState == 'function') {
    var stateObj = {
      filters: this.$element.serializeArray()
    }
    history.pushState(stateObj, "page", "example.html?"+this.new_url);
  }
}
Filter.prototype.onStateChange = function(e) {
  this.clearRadios();
  if(e.originalEvent.state){
    this.updateRadios(e.originalEvent.state.filters)
  }
  this.getData();
}

Filter.prototype.clearRadios = function(){
  var checkedRadios = this.$element.find('input[type=radio]:checked');
  this.setRadios(checkedRadios, false);
}

Filter.prototype.updateRadios = function(radiosToUpdate){
  for (var i=0; i < radiosToUpdate.length; i++){
    var radioToCheck = this.$element.find("[value=" + radiosToUpdate[i].value + "]");
    this.setRadios(radioToCheck, true);
  }
}
Filter.prototype.setRadios = function(elementRadios,stateRadios) {
    elementRadios.prop("checked",stateRadios);
}

window.FILTERAPP.Filter = Filter;

