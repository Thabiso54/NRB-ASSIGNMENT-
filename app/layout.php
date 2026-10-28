<?php
function page_header(string $title): void {
    $flash = take_flash();
    ?><!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title><?= e($title) ?> · NRB</title><link rel="stylesheet" href="assets/style.css"></head><body>
    <header class="topbar"><a class="brand" href="index.php"><span class="brand-mark">NRB</span><span>National ID Registry<small>Registration & issuance portal</small></span></a>
    <?php if (!empty($_SESSION['user_id'])): ?><nav><a href="index.php">Dashboard</a><a href="applicants.php">Applicants</a><a href="applicant_form.php">Register applicant</a><a href="cards.php">ID cards</a><a href="change_password.php">Password</a><a href="logout.php">Sign out</a></nav><?php endif; ?></header><main class="container">
    <?php if ($flash): ?><div class="alert <?= e($flash['type']) ?>" role="status"><?= e($flash['message']) ?></div><?php endif; ?>
    <div class="page-heading"><div><p class="eyebrow">NATIONAL REGISTRATION BUREAU</p><h1><?= e($title) ?></h1></div></div><?php
}
function page_footer(): void { ?></main><footer class="footer">NRB Registration System · Academic demonstration using fictional data · <span><?= date('Y') ?></span></footer><script src="assets/app.js"></script></body></html><?php }
