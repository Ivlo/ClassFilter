var Device = function(window, Device, ranges){
  var window = $(window),
      window_width = window.width(),
      range, min, max, device, event, has_touchevents;
  
  // Utils
  function debounce(b,c){var a;return function(){var d=[].slice.call(arguments);if(a){clearTimeout(a)}a=setTimeout($.proxy(function(){b.apply(this,d)},this),c)}};
    
  // Si estamos en una version inferior a IE9, siempre es desktop
  
  if($.browser.msie && parseFloat($.browser.version) < 9){
    for(device in ranges){
      Device["is_"+device] = device == "desktop" ? false : true;
    }
    Device.device_type = function(){ return "desktop"; }
    Device.is = function(device_type){ return device_type == "desktop"; }
    Device.refresh = $.noop;
    return Device; // Cortamos la ejecucion y devolvemos "Device" con todas las
                   // propiedades y metodos para IE8- 
  }
  
  Device.device_type = function(){
    window_width = window.width();
    for (device in ranges){
      range = ranges[device],
      min = range[0], max = range[1];
      if(window_width >= min && (!max || window_width <= max))
        return device;
    }
    return null;
  }
  
  Device.is = function(device_type){
    window_width = window.width(),
    range = ranges[device_type],
    min = range[0], 
    max = range[1];
    
    return window_width >= min && (!max || window_width <= max)
  }
  
  Device.refresh = function(){
    var changed = false,
        val, new_val, device_type, last_device_type;
    for (device in ranges){
      val = Device[ 'is_'+device ],
      new_val = Device.is(device);
      if(val != new_val){
        Device[ 'is_'+device ] = new_val;
        if(!!new_val){
          device_type = device;
        }
        if(!changed)
          changed = true;
      }
    }  
    if(changed){
      window.trigger($.Event("device_change", {device:device_type}));
    }
  }  
  
  window.on("resize", debounce(function(){
    Device.refresh();
  },100))
  
  Device.refresh();
  
  return Device;
}(window, {}, {
                'desktop' :[992],
                'tablet' : [768, 991],
                'mobile' : [0, 767]
              });