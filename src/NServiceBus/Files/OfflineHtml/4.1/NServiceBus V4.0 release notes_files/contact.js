//<![CDATA[
function IsEmail(email) {
    var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
};     /// test!!!   
function showContactUs() {
    $("#contact-us-button").click();
};
//                                                  !!!loldma: added apiurl parameter!!!
function addRed(input) {
    //if (window.location.href.indexOf("testcontactform") > -1) {
    input.addClass("validateerror");
    input.parent().parent().children().first().addClass("validateerrortext");
    //}
}
function removeRed(input) {
    //if (window.location.href.indexOf("testcontactform") > -1) {
        
    
    input.removeClass("validateerror");
    input.parent().parent().children().first().removeClass("validateerrortext");}
//}
function checkfields(id,apiurl,template) {    
    var d = new Date();
    if ($("#override-"+template).length > 0 && $("#override-"+template).val().length > 0) {
        template = $("#override-"+template).val();
    }
    $(id + " .data").val(d);
    $(id + " .url").val(window.location.href);
    $(id + " .form-horizontal button[type=submit]").click(function () {
        $(id + " .messageboxerror").hide();
        var ret = true;
        if ($(id + " .firstname").val().trim() == "") {
    //        $(id + " .firstname").attr("placeholder", "Field is missing");
            addRed($(id + " .firstname"))
            ret = false;
        }
        else {
            $(id + " .firstname").removeAttr("placeholder");
            removeRed($(id + " .firstname"));
        }
        if ($(id + " .lastname").val().trim() == "") {
     //       $(id + " .lastname").attr("placeholder", "Field is missing");
            addRed($(id + " .lastname"));
            ret = false;
        }
        else {
            $(id + " .lastname").removeAttr("placeholder");
            removeRed($(id + " .lastname"));
        }
        if ($(id + " .email").val().trim() == "") {
    //        $(id + " .email").attr("placeholder", "Field is missing");
            addRed($(id + " .email"));
            ret = false;
        }
        else {
            if (!IsEmail($(id + " .email").val().trim())) {
                $(id + " .email").val("");
    //            $(id + " .email").attr("placeholder", "Email isn't valid");
                addRed($(id + " .email"));
                ret = false;
            } else {
                $(id + " .email").removeAttr("placeholder");
                removeRed($(id + " .email"));
            }
        }
        if ($(id + " textarea").val().trim() == "") {
    //        $(id + " textarea").attr("placeholder", "Field is missing");
            addRed($(id + " textarea"));
            ret = false;
        }
        else {
            $(id + " .message").removeAttr("placeholder");
            removeRed($(id + " textarea"));
        }
        // Backend API: Start call Contact us
        if (ret) {            
            var contextData = "<br>" + $(id + " textarea").val().trim() + " <br/><br/></br>";
            contextData += "<br>Sent From URL: " + $(id + " .url").val().trim() + " </br>";
            contextData += "<br>Timestamp: " + $(id + " .data").val().trim() + " </br>";
            if (typeof temptemplateid !== "undefined" && temptemplateid != "") {
                template = temptemplateid;
                temptemplateid = "";
            }
            if ($("#otherContextData").length > 0)
                contextData += $("#otherContextData").val();
            var postData = {
                FirstName: $(id + " .firstname").val().trim(),
                LastName: $(id + " .lastname").val().trim(),
                Company: $(id + " .company").val(),
                Email: $(id + " .email").val().trim(),
                Phone: $(id + " .phone").val(),
                templateid: template,
                Context: contextData
            };
            console.log(postData);
            $.ajax({
                url: apiurl,
                type: "POST",
                data: postData,
                success: function (data, textStatus, xhr) {
                    $(".fancybox-close").click();
                },
                complete: function (xhr, textStatus) {
                    if (textStatus == "success")
                        generateSuccessErrorBox("<h3><b>Thank you for your message. We will get back to you soon</b></h3>",0);
                    else
                        generateSuccessErrorBox("<h3><b>Oops! something went wrong and we could not send your request. Sorry for the extra work. Please send us an old fashioned e-mail to support@particular.net</b></h3>",1);                
                }
            });
        }
        else {
            //if (window.location.href.indexOf("testcontactform") > -1) {
                $(id + " .messageboxerror").show();
            //}
        }
        //$.post("/api/contactus", postData);
        // Backend API: End call Contact us
        return false;
    });
};

$(function () {
    $('.contactus-button .active').hide();
    $('.contactus-button a').click(function () {
        var isActive = $(this).attr('class');
        if (isActive == "inactive") {
            $('.contactus-button .inactive').hide();
            $('.contactus-button').css('margin-top', '0');
            $('.contactus-button .active').show();
            $('.contactus-menu').show();
        }
        else {
            $('.contactus-button .active').hide();
            $('.contactus-button').css('margin-top', '-68px');
            $('.contactus-button .inactive').show();
            $('.contactus-menu').hide();
        }
    });
    $(".fancybox").fancybox();
    $('.menu a[href*="/ask"]').attr("href", "#ask-a-question");
    $('a[href*="#ask-a-question"]').fancybox();

    checkfields("#contact-us-block","/api/contactus","RequestForContact");
    checkfields("#ask-a-question", "/api/contactus","ParticularQuestion");
});


function generateSuccessErrorBox(text,type) {
    var regEx = /(\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)/;
    text=text.replace(regEx, "<a href=\"mailto:$1\">$1</a>");
    if ($("#succErrBoxContact").length <= 0) {
        
        var box = $("<div id='succErrBoxContact'>" + text + "</div>");
        box.css({
            "display": "none",
            "position": "absolute",
            "z-index": "60000",
            "text-align": "center",
            "v-align": "middle",
            "padding-left": "20px",
            "padding-right": "20px",           
            "margin-top": "185px",
            "left": "0",
            boxShadow: "0 1px 5px rgba(0,0,0,.5)",
            "top": "0"
        });
        box.click(function(){            
            $(this).hide();            
        });
        $("body").append(box);

    }
    else {
        $("#succErrBoxContact").html(text);
    }
    
    $("#succErrBoxContact").css({
        "margin-left": (($(document).width()-$("#succErrBoxContact").width())/2)+"px",
        "background-color": ["#47d9b2","#d54938"][type],
        "color": ["#000","#fff"][type]
        });
    $("#succErrBoxContact a").css({"color":["#000","#fff"][type]});
    $("#succErrBoxContact").fadeIn(300);
    $(document).scrollTop(0);
    $("#succErrBoxContact").delay([10000,60000][type]).fadeOut(300);
    
}
//]]>