//= require "./browser"
//= require "./underscore"
var Device = function(window, Device, ranges){

  var device;
  
  Device.ranges = ranges;
  
  // Si estamos en una version inferior a IE9, siempre es desktop
  
  if(Browser.is_msie("< 9")){
    for(device in ranges){
      Device["is_"+device] = device == "desktop" ? true : false;
    }
    Device.device_type = function(){ return "desktop"; }
    Device.is = function(device_type){ return device_type == "desktop"; }
    Device.debug = Device.log = Device.refresh = $.noop;
    Device.current_device = "desktop";
    return Device; // Cortamos la ejecucion y devolvemos "Device" con todas las
                   // propiedades y metodos para IE8- 
  }

  var width_method = 'innerWidth' in window ? "innerWidth" : "clientWidth",
      width_target = width_method == "innerWidth" ? window : (document.documentElement || document.body),
      device_width = function(){
        return width_target[width_method];
      }; // http://stackoverflow.com/questions/11309859/media-queries-and-window-width
  
  Device.log = $.noop;

  Device.debug = function(){
    var console = $("<div style='position:fixed; left:0; top:0; background-color:#FFD000; border:3px solid #DE5050; color:#B83509; z-index:99999; padding:10px; font-size:1.5em; border-radius:5px;'/>");
    $("body").append(console);
    Device.log = function(){
      console.html("<p>Width: "+device_width()+"</p>"+
                   "<p>Device: "+Device.current_device+"</p>"+
                   "<p>Range: "+ranges[Device.current_device]+"</p>")
    }
    Device.log();
  }

  Device.device_type = function(){
    var window_width = device_width(),
        range, min, max, device;
    for (device in ranges){
      range = ranges[device],
      min = range[0], max = range[1];
      if(window_width >= min && (!max || window_width <= max))
        return device;
    }
    return null;
  }
  
  Device.is = function(device_type){
    var window_width = device_width(),
        range = ranges[device_type],
        min = range[0],
        max = range[1];
    
    return window_width >= min && (!max || window_width <= max)
  }
  
  Device.refresh = function(force){
    force || (force = false);
    var changed = false,
        val, new_val, last_device_type,
        device;
    for (device in ranges){
      val = Device[ 'is_'+device ],
      new_val = Device.is(device);
      if(val != new_val){
        Device[ 'is_'+device ] = new_val;
        if(!!new_val){
          last_device_type = Device.current_device;
          Device.current_device = device;
        }
        if(!changed) changed = true;
      }
    }  
    
    if(changed || force){
      $(window).trigger($.Event("device_change", {device: Device.current_device, prev_device: last_device_type}));      
    }
  }  
  


  $(window).on("resize", _.debounce(function(){
    Device.refresh();
    Device.log();
  },100))
  
  Device.refresh();
  
  return Device;
}(window, {}, {
                'desktop' :[991],
                'tablet' : [768, 990],
                'mobile' : [0, 767]
              });
