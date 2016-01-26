
        var remote_url = 'http://douchat.cc/';
        $(function(){

          
          // 获取艾豆问答社区开发交流版块的数据
            $.ajax({
                 url:remote_url+'wenda/?/interface/question/',
                 dataType: 'jsonp', 
                 data:'callback=jsonpcallback_communication',  
                 jsonp:'callback', 
            });

            // 获取艾豆问答社区开发教程版块的数据
            $.ajax({
                 url:remote_url+'wenda/?/interface/article/',
                 dataType: 'jsonp', 
                 data:'callback=jsonpcallback_course',  
                 jsonp:'callback',
            });

            // 获取艾豆问答社区应用商城版块的数据
            $.ajax({
                 url:remote_url+'wenda/?/interface/shop/',
                 dataType: 'jsonp', 
                 data:'callback=jsonpcallback_appstore',  
                 jsonp:'callback',
            });

            $.ajax({
                 url:remote_url+'wenda/?/interface/notice/',
                 dataType: 'jsonp', 
                 data:'callback=jsonpcallback_notice',  
                 jsonp:'callback', 
            });

            $.ajax({
                 url:remote_url+'wenda/?/interface/feedback/',
                 dataType: 'jsonp', 
                 data:'callback=jsonpcallback_feedback',  
                 jsonp:'callback', 
            });


          $(".set_status").click(function(){
            var href = $(this).attr("href");
            window.location.href = href;
          });
        });

        function jsonpcallback_communication(data){
          
          jsonpcallback_show_data(data,'communication');
          
        }

        function jsonpcallback_appstore(data){
          
          jsonpcallback_show_shop_data(data,'appstore');
          
        }

        function jsonpcallback_course(data){
          
          jsonpcallback_show_data(data,'course');
          
        }

        function jsonpcallback_notice(data){
          
          jsonpcallback_show_data(data,'notice');
          
        }

        function jsonpcallback_feedback(data){
          
          jsonpcallback_show_data(data,'feedback');
          
        }

        function jsonpcallback_show_data(data,area){
          $.each(data,function(i,item){
            if ( area == 'communication' ){
              var item = '<li class="mp_news_item">'+
                      '<a href="'+remote_url+'wenda/?/question/'+item.question_id+'" target="_blank" title="'+data[i].title+'">'+
                          '<strong style="width:300px;">'+data[i].question_content;
                      if (i<3){
                        item += '<i class="icon_common new"></i>';
                      }
                        
                        item += '</strong>'+
                          '<span class="read_more">'+data[i].add_time+'</span>'+
                      '</a>'+
                  '</li>';
              } else if ( area == 'course' ) {
                var item = '<li class="mp_news_item">'+
                    '<a href="'+remote_url+'wenda/?/article/'+item.id+'" target="_blank" title="'+data[i].title+'">'+
                        '<strong style="width:300px;">'+data[i].title
                    if (i<3){
                      item += '<i class="icon_common new"></i>';
                    }
                      
                      item += '</strong>'+
                        '<span class="read_more">'+data[i].add_time+'</span>'+
                    '</a>'+
                  '</li>';
              } else if ( area == 'notice' ) {
                var item = '<li class="mp_news_item">'+
                    '<a href="'+remote_url+'wenda/?/notice/'+item.id+'" target="_blank" title="'+data[i].title+'">'+
                        '<strong style="width:300px;">'+data[i].title
                    if (i<3){
                      item += '<i class="icon_common new"></i>';
                    }
                      
                      item += '</strong>'+
                        '<span class="read_more">'+data[i].add_time+'</span>'+
                    '</a>'+
                  '</li>';
              } else if ( area == 'feedback' ) {
                var item = '<li class="mp_news_item">'+
                    '<a href="'+remote_url+'wenda/?/feedback/'+item.id+'" target="_blank" title="'+data[i].title+'">'+
                        '<strong style="width:300px;">【'+data[i].category_id+'BUG】'+data[i].title
                    if (i<3){
                      item += '<i class="icon_common new"></i>';
                    }
                      
                      item += '</strong>'+
                        '<span class="read_more">'+data[i].add_time+'</span>'+
                    '</a>'+
                  '</li>';
              }

                $("#"+area).append(item);
          });
        }

        function jsonpcallback_show_shop_data(data,area){
          $.each(data,function(i,item){
              if (data[i].pay_type == 0) {
                var price = '免费';
              } 

              if (data[i].pay_type == 1) {
                var price = data[i].price+'积分';
              }

              if (data[i].pay_type == 2) {
                var price = data[i].price+'豆币';
              }
              var item = '<li class="mp_news_item">'+
                      '<a href="'+remote_url+'wenda/?/shop/'+item.id+'" target="_blank" title="'+data[i].title+'">'+
                        '<img src="http://idouly.com/wenda/'+data[i].cover+'">'+
                        '<h4 class="title">'+data[i].title+'</h4>'+
                        '<h4 class="price">售价：<span style="color:#ff6600;">'+price+'</span><span class="view">'+data[i].views+'人看过</span></h4>'+
                      '</a>'+
                    '</li>';
              
              $("#"+area).append(item);
          });
        }

        
               

