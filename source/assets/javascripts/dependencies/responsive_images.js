;(function(window, $, undefined){
  ResponsiveImages = function(element,options){
    this.on_device_change = $.proxy(this.on_device_change, this);
    
    this.options = $.extend({}, ResponsiveImages.DEFAULTS, options);
    this.element = element;

    this.sources = {};
    this.source = null;
    
    this.init();
  };
  
  ResponsiveImages.DEFAULTS = {
    resize_delay: 100,
    devices: ["mobile", "tablet", "desktop"],
    default_size: "default"
  };
  
  $.extend(ResponsiveImages.prototype,{
    
    init:function(){
      this.get_sources();
      this.bind_events();
      this.on_device_change({device:Device.device_type()});
    },
    
    get_sources:function(){
      var i, source, device,
          sources = this.options.devices,
          sources_length;
      sources.push(this.options.default_size);
      
      sources_length = sources.length;
      for(i = sources_length; i--;){
        device = sources[i];
        source = this.element.data(device+"-src");
        if(source)
          this.sources[device] = source;
      }
      sources.pop();
    },
    
    bind_events: function(){
      $(window).on("device_change", this.on_device_change)
    },
    
    on_device_change: function(e){
      var device_type = e.device,
          source = this.sources[device_type];
      if(this.element.is("[data-no-"+device_type+"-src]")) source = "#";
      else if(!source) source = this.sources["default"] || "#";
    
      if(source != this.source)
        this.change_source(source)
    },
    
    change_source: function(source){
      this.source = source;
      this.element.attr("src", source);
      this.element.trigger("src_change");
    }
    
  });  
  
  $.fn.responsive_images = function(options){
    return this.each(function(){
      var self = $(this);
      if(!self.data("responsiveimages")){
        self.data("responsiveimages", new ResponsiveImages(self, options));
      }
    });
  };  
  
  $.fn.responsive_images.proto = ResponsiveImages;
  
})(window, jQuery);