<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>

    //用户是否为微信浏览器
    var wechatUser = false;

    //用户是否为易班浏览器
    var yibanUser = false;

    //消除iOS点击延迟
    $(function () {
        FastClick.attach(document.body);
    });

    //检查用户浏览器属性
    $(function () {
        <c:if test="${sessionScope.yiBanUserID!=null}">
        //易班登录
        yibanUser = true;
        </c:if>
        if (navigator.userAgent.toLowerCase().match(/MicroMessenger/i) == "micromessenger") {
            //微信登录
            wechatUser = true;
        }
    });

    //加载个人姓名信息和头像地址
    $(function () {
        $.ajax({
            url: '/rest/profile',
            async: true,
            type: 'get',
            success: function (result) {
                if (result.success === true) {
                    let realname = result.data.realname == null ? "暂未录入" : result.data.realname;
                    $("#right_name").text(realname);
                }
            }
        });
        $.ajax({
            url: '/rest/avatar',
            async: true,
            type: 'get',
            success: function (result) {
                if (result.success === true) {
                    if (result.data !== '') {
                        $("#right_avatar").attr("src", result.data);
                    }
                }
            }
        });
    });

    //重新调整单元格边框属性
    $(function () {
        let functionSize = $("[class='links']").find("div").length;
        let j = 0;
        for (let i = 0; i < functionSize; i++) {
            if (!$("[class='links']").find("div").eq(i).is(":hidden")) {
                if ((j + 1) % 1 == 0) {
                    $("[class='links']").find("div").eq(i).css("border-right", "1px solid #E2E0E3")
                }
                else if ((j + 1) % 2 == 0) {
                    $("[class='links']").find("div").eq(i).css("border-right", "1px solid #E2E0E3")
                }
                if ((j + 1) % 3 == 0) {
                    $("[class='links']").find("div").eq(i).css("border-right", "0px");
                }
                j++;
            }
        }
    });

    //进行体测查询系统
    function linkToPFTSystem() {
        if (wechatUser) {
            window.location.href = 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxa2d196aa4b8a7600&redirect_uri=http%3A%2F%2F5itsn.com%2FWeixin%2FOAuth2%2FUserInfoCallback&response_type=code&scope=snsapi_userinfo&state=TestUrlTestResult&connect_redirect=1#wechat_redirect';
        }
        else {
            weui.alert('请关注微信公众号广东二师助手使用体测查询功能', {
                title: '请使用微信客户端进行登录',
                buttons: [{
                    label: '确定',
                    type: 'primary'
                }]
            });
        }
    }

    //弹出重新绑定易班确认框
    function showYibanAttachConfirm() {
        if (yibanUser) {
            weui.confirm('重新绑定易班账号将退出当前账号，你确定吗？', {
                title: '重新绑定易班',
                buttons: [{
                    label: '取消',
                    type: 'default'
                }, {
                    label: '确定',
                    type: 'primary',
                    onClick: function () {
                        window.location.href = '/yiban/attach';
                    }
                }]
            });
        }
        else {
            weui.alert('请使用易班客户端进行登录', {
                title: '错误提示',
                buttons: [{
                    label: '确定',
                    type: 'primary'
                }]
            });
        }
    }

    //弹出退出确认框
    function showLogoutConfirm() {
        if (!yibanUser) {
            weui.confirm('你确定退出当前账号并清除账号缓存吗？', {
                title: '退出当前账号',
                buttons: [{
                    label: '取消',
                    type: 'default'
                }, {
                    label: '退出',
                    type: 'primary',
                    onClick: function () {
                        window.location.href = '/logout';
                    }
                }]
            });
        }
        else {
            weui.alert('易班客户端不支持账号退出，你可以重新绑定易班账号', {
                title: '错误提示',
                buttons: [{
                    label: '确定',
                    type: 'primary'
                }]
            });
        }
    }

</script>