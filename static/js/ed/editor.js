
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
  $("ul.navbar-nav").append(
    $("<li>", { class: "nav-item", id: "nav-login" }).append(
      $("<a>", { class: "nav-link" })
        .append($("<span>").text("LOGIN "))
        .append($("<i class='now-ui-icons users_circle-08'></i>"))
        .attr("href", "javascript:tclb_editor_login();")
    ).hide()
  );
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
    )
  );
})

function tclb_editor_disp_prof(profile) {
          $("#nav-profile-avatar").attr("src",profile.avatar_url);
          $("#nav-logout").show();
}

function tclb_editor_check_login() {
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
          Cookies.set('gh_profile',profile);
        } else {
          console.log(err);
        }
      });
    }
  } else {
    $("#nav-login").show();
    $("#nav-logout").hide();
  }
}

$(function() { tclb_editor_check_login(); })
