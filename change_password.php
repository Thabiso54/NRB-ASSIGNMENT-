<?php
require __DIR__.'/app/bootstrap.php'; require_login(); require __DIR__.'/app/layout.php';
$errors=[];
if($_SERVER['REQUEST_METHOD']==='POST'){
    verify_csrf(); $current=(string)($_POST['current_password']??''); $new=(string)($_POST['new_password']??''); $confirm=(string)($_POST['confirm_password']??'');
    $st=$pdo->prepare('SELECT password_hash FROM users WHERE id=? AND is_active=1'); $st->execute([$_SESSION['user_id']]); $user=$st->fetch();
    if(!$user || !password_verify($current,$user['password_hash'])) $errors[]='Current password is incorrect.';
    if(strlen($new)<12 || !preg_match('/[A-Z]/',$new) || !preg_match('/[a-z]/',$new) || !preg_match('/[0-9]/',$new)) $errors[]='New password must be at least 12 characters and include uppercase, lowercase and a number.';
    if($new!==$confirm) $errors[]='New password and confirmation do not match.';
    if($current===$new) $errors[]='Choose a password different from your current password.';
    if(!$errors){$st=$pdo->prepare('UPDATE users SET password_hash=? WHERE id=?');$st->execute([password_hash($new,PASSWORD_DEFAULT),$_SESSION['user_id']]);log_activity($pdo,'CHANGE_PASSWORD',null,'Password changed');session_regenerate_id(true);flash('success','Password changed successfully.');redirect('index.php');}
}
page_header('Change password'); ?>
<?php if($errors): ?><div class="alert error"><ul><?php foreach($errors as $err): ?><li><?=e($err)?></li><?php endforeach; ?></ul></div><?php endif; ?>
<form class="panel form-panel" method="post"><input type="hidden" name="csrf" value="<?=e(csrf_token())?>"><div class="section-title"><h2>Update your password</h2><p>Use a unique password that you do not use on other sites.</p></div><div class="form-grid"><label class="span-2">Current password<input type="password" name="current_password" required autocomplete="current-password"></label><label>New password<input type="password" name="new_password" required minlength="12" autocomplete="new-password"><small class="muted">12+ characters, uppercase, lowercase and number.</small></label><label>Confirm new password<input type="password" name="confirm_password" required minlength="12" autocomplete="new-password"></label></div><div class="form-actions"><a class="btn secondary" href="index.php">Cancel</a><button class="btn primary" type="submit">Change password</button></div></form>
<?php page_footer(); ?>
