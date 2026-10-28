<?php
require __DIR__.'/app/bootstrap.php'; require __DIR__.'/app/layout.php';
if (!empty($_SESSION['user_id'])) redirect('index.php');
$error='';
if ($_SERVER['REQUEST_METHOD']==='POST') { verify_csrf(); $username=trim((string)($_POST['username']??'')); $password=(string)($_POST['password']??'');
    $st=$pdo->prepare('SELECT id, username, password_hash, full_name FROM users WHERE username=? AND is_active=1'); $st->execute([$username]); $u=$st->fetch();
    if ($u && password_verify($password,$u['password_hash'])) { session_regenerate_id(true); $_SESSION['user_id']=(int)$u['id']; $_SESSION['username']=$u['username']; $_SESSION['full_name']=$u['full_name']; $pdo->prepare('UPDATE users SET last_login=NOW() WHERE id=?')->execute([$u['id']]); flash('success','Welcome back, '.$u['full_name'].'.'); redirect('index.php'); }
    $error='Invalid username or password.';
}
page_header('Sign in'); ?>
<section class="auth-card"><div class="auth-icon">ID</div><h2>Welcome back</h2><p class="muted">Sign in to manage fictional applicant records.</p><?php if($error): ?><div class="alert error"><?=e($error)?></div><?php endif; ?><form method="post"><input type="hidden" name="csrf" value="<?=e(csrf_token())?>"><label>Username<input name="username" autocomplete="username" required maxlength="60" autofocus></label><label>Password<input type="password" name="password" autocomplete="current-password" required></label><button class="btn primary full" type="submit">Sign in securely</button></form><p class="hint">First run? Import <code>sql/schema.sql</code> and <code>sql/sample_data.sql</code>. Demo login is in README.md; change it immediately.</p></section>
<?php page_footer(); ?>
