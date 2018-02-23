
var tclb_sec_cookie = true;
var tclb_im_sec = false;;

$(function() {
  if (location.hostname == "localhost") {
    tclb_sec_cookie = false;
    tclb_im_sec = true;
  } else {
    if (location.protocol == "https:") {
      tclb_im_sec = true;
    }
  }
})

function tclb_go_sec() {
  if (location.protocol !== "https:") location.protocol = "https:";
}

function tclb_editor_login () {
      var authenticator = new netlify.default ({site_id: "tclb.io"});
      authenticator.authenticate({provider:"github", scope: "user"}, function(err, data) {
        if (err) {
          return alert("Error Authenticating with GitHub: " + err);
        }
        Cookies.set('gh_token',data.token, { secure: tclb_sec_cookie });
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
  $("ul.navbar-nav").append(
    $("<li>", { class: "nav-item dropdown", id: "nav-logout" }).append(
      $("<a>", { class: "nav-link dropdown-toggle", id:"navbarDropdownMenuLink", 'data-toggle':"dropdown" })
        .append($("<span>", { class:"caret" }))
        .attr("href", "#")
        .append(
          $("<div>", { class: "avatar-container" }).append(
            $("<img>", { id: "nav-profile-avatar", class: "avatar-img rounded-circle" })
          )
        )
    ).append(
      $("<div>", { class: "dropdown-menu dropdown-menu-right", 'aria-labelledby': "navbarDropdownMenuLink"})
        .append(
          $("<a>", { class: "dropdown-item" })
            .append($("<span>").text("LOGOUT"))
            .attr("href", "javascript:tclb_editor_logout();")
        )
    ).hide()
  );
})


function tclb_editor_disp_prof(profile) {
          $("#nav-profile-avatar").attr("src",profile.avatar_url);
          $("#nav-logout").show();
}

function tclb_editor_check_login() {
  if (tclb_im_sec) {
    var gh_token = Cookies.get('gh_token');
    if (gh_token) {
      console.log(gh_token);
      $("#nav-login").hide();
      profile =  Cookies.getJSON('gh_profile');
      if (profile) {
        tclb_editor_disp_prof(profile);
      } else {
        var gh = new GitHub({
          token: gh_token
        });
        var me = gh.getUser();
        console.log(me);
        me.getProfile(function(err, profile) {
          if (! err) {
            console.log(profile);
            tclb_editor_disp_prof(profile);
            Cookies.set('gh_profile',profile, { secure: tclb_sec_cookie });
          } else {
            console.log(err);
          }
        });
      }
    } else {
      $("#nav-login a").attr("href", "javascript:tclb_editor_login();");
      $("#nav-login a i").attr("class", "now-ui-icons users_circle-08");
      $("#nav-login").show();
      $("#nav-logout").hide();
    }
  } else {
      $("#nav-login a").attr("href", "javascript:tclb_go_sec();");
      $("#nav-login").show();
      $("#nav-logout").hide();
  }    
}

$(function() { tclb_editor_check_login(); })
