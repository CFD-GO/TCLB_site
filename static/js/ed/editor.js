
function tclb_editor_login () {
      var authenticator = new netlify.default ({site_id: "tclb.io"});
      authenticator.authenticate({provider:"github", scope: "user"}, function(err, data) {
        if (err) {
          return alert("Error Authenticating with GitHub: " + err);
        }
        Cookies.set('gh_token',data.token);
        tclb_editor_check_login();
      });
}

function tclb_editor_logout () {
  Cookies.remove('gh_token');
  tclb_editor_check_login();
}


function tclb_editor_open () {
  alert("open");
}

function tclb_editor_save () {
  alert("save");
}

$(function() {
  a = $("<a>", { class: "nav-link" });
  a.text("LOGIN");
  a.attr("href", "javascript:tclb_editor_login();");
  li = $("<li>", { class: "nav-item", id: "nav-login" });
  li.append(a);
  li.hide();
  $("ul.navbar-nav").append(li);
  img = $("<img>", { id: "nav-profile-avatar", class: "avatar-img rounded-circle" });
  imgdiv = $("<div>", { class: "avatar-container" });
  a = $("<a>", { class: "nav-link" });
  a.text("LOGOUT");
  a.attr("href", "javascript:tclb_editor_logout();");
  a.append(img);
  li = $("<li>", { class: "nav-item", id: "nav-logout" });
  li.hide();
  imgdiv.append(img);
  a.append(imgdiv);
  li.append(a);
  $("ul.navbar-nav").append(li);
})

function tclb_editor_check_login() {
  var gh_token = Cookies.get('gh_token');
  if (gh_token) {
    console.log(gh_token);
    $("#nav-login").hide();
    var gh = new GitHub({
      token: gh_token
    });
    var me = gh.getUser();
    console.log(me);
    me.getProfile(function(err, profile) {
      if (! err) {
        console.log(profile);
        $("#nav-profile-avatar").attr("src",profile.avatar_url);
        $("#nav-logout").show();
      } else {
        console.log(err);
      }
    });
  } else {
    $("#nav-login").show();
    $("#nav-logout").hide();
  }
}

$(function() { tclb_editor_check_login(); })
