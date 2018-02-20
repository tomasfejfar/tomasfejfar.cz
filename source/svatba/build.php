<?php

declare(strict_types = 1);

$file = 'index.html';
$content = file_get_contents($file);
$galleryContent = '<!--gallery-->' . getGallery() . '<!--e_gallery-->';
$content = preg_replace('/<!--gallery-->(.*)<!--e_gallery-->/smu', $galleryContent, $content, -1, $count);
file_put_contents($file, $content);

function getGallery() {
    chdir('fotky');
    $files = glob('*.jpg');
    shuffle($files);
    $result = PHP_EOL . '<div class="grid">'. PHP_EOL;
    foreach ($files as $picture) {
        $template = <<<HTML
                        <div class="grid-item">
                            <a href="fotky/%s" data-src="fotky/%s" class="link">
                                <img src="fotky/t/%s" class="img-thumbnail">
                            </a>
                        </div>
HTML;
        $result .= sprintf($template, $picture, $picture, $picture) . PHP_EOL;
    }
    chdir('..');
    $result .= '</div>' . PHP_EOL;
    return $result;
}
