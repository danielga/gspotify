<?php
$gspotify_client_id = "5b94f2519b444963b0a05f93090a4c99";
$gspotify_client_secret = file_get_contents(".client_secret");
if ($gspotify_client_secret === FALSE) {
    http_response_code(400);
    trigger_error("Gspotify client secret wasn't set", E_USER_NOTICE);
    return;
}

if (!isset($_GET["code"])) {
    http_response_code(400);
    trigger_error("Token request code wasn't set", E_USER_NOTICE);
    return;
}

$data = http_build_query(array(
    "grant_type" => "authorization_code",
    "code" => $_GET["code"],
    "redirect_uri" => "https://gspotify.metaman.xyz/authorize"
));
$opts = array(
    "http" => array(
        "method" => "POST",
        "header" => "Authorization: Basic " . base64_encode($gspotify_client_id . ":" . $gspotify_client_secret) . "\r\n" .
                    "Content-type: application/x-www-form-urlencoded\r\n" .
                    "Content-Length: " . strlen($data) . "\r\n",
        "content" => $data
    )
);
$context = stream_context_create($opts);
$result = file_get_contents("https://accounts.spotify.com/api/token", false, $context);
if ($result === FALSE) {
    http_response_code(400);
    trigger_error("Token request failed", E_USER_NOTICE);
    return;
}

header("Content-Type: application/json");
print $result;
?>
