import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var lastVolume:Float = -1;
var lastMuted:Bool = false;
var isShowing:Bool = false;

var volBG:FlxSprite;
var volBar:FlxSprite;

var tweenBG:FlxTween;
var tweenBar:FlxTween;

// Configurações da Barra
var topoEscondido:Float = -120; // Posição Y fora da tela
var topoVisivel:Float = 20;     // Posição Y no centro/topo
var tempoNaTela:Float = 2.0;    // Tempo antes de sumir
var velocidadeTween:Float = 0.25;

// Timer numérico para substituir o FlxTimer bugado
var cooldownTimer:Float = -1;

function onCreatePost() {
    // Desativa a barra de volume padrão do HaxeFlixel
    FlxG.sound.soundTrayEnabled = false;

    // Criar o fundo da barra
    volBG = new FlxSprite(0, topoEscondido);
    volBG.loadGraphic(Paths.image('soundBar/backgroundVolume'));
    volBG.cameras = [game.camOther]; // Mantém na câmera "Other" (acima de tudo)
    volBG.x = (FlxG.width - volBG.width) / 2; // Centraliza no eixo X
    game.add(volBG);

    // Criar o indicador de volume (barras/mute)
    volBar = new FlxSprite(0, topoEscondido);
    volBar.loadGraphic(Paths.image('soundBar/mute'));
    volBar.cameras = [game.camOther];
    volBar.x = (FlxG.width - volBar.width) / 2;
    game.add(volBar);
}

function onUpdatePost(elapsed:Float) {
    // Garante que não vai rodar nada se os sprites ainda não existirem na memória
    if (volBG == null || volBar == null) return;

    var currentVolume:Float = FlxG.sound.volume;
    var currentMuted:Bool = FlxG.sound.muted;

    // Evita tocar a animação logo ao iniciar a música
    if (lastVolume == -1) {
        lastVolume = currentVolume;
        lastMuted = currentMuted;
        return;
    }

    // Se houver qualquer alteração no volume ou mute, atualiza a barra
    if (currentVolume != lastVolume || currentMuted != lastMuted) {
        lastVolume = currentVolume;
        lastMuted = currentMuted;
        showVolumeTray(currentVolume, currentMuted);
    }

    // Diminui o tempo restante a cada frame (Substitutos do FlxTimer)
    if (cooldownTimer > 0) {
        cooldownTimer -= elapsed;
        if (cooldownTimer <= 0) {
            hideVolumeTray();
        }
    }
}

function showVolumeTray(vol:Float, muted:Bool) {
    // Reseta o tempo de tela toda vez que você altera o volume
    cooldownTimer = tempoNaTela;

    // Cancela os tweens ativos para não dar conflito se você apertar rápido demais
    if (tweenBG != null) tweenBG.cancel();
    if (tweenBar != null) tweenBar.cancel();

    // Troca a imagem dependendo do estado atual do áudio
    if (muted || vol <= 0) {
        volBar.loadGraphic(Paths.image('soundBar/mute'));
    } else {
        var barIndex:Int = Std.int(vol * 10 + 0.5);
        if (barIndex < 1) barIndex = 1;
        if (barIndex > 10) barIndex = 10;
        
        volBar.loadGraphic(Paths.image('soundBar/bars_' + barIndex));
    }

    // Recalcula o centro
    volBG.x = (FlxG.width - volBG.width) / 2;
    volBar.x = (FlxG.width - volBar.width) / 2;

    // Se estava escondido, força começar lá de cima
    if (!isShowing) {
        volBG.y = topoEscondido;
        volBar.y = topoEscondido;
        isShowing = true;
    }

    // Tween de entrada (Desce para a tela)
    tweenBG = FlxTween.tween(volBG, {y: topoVisivel}, velocidadeTween, {ease: FlxEase.cubeOut});
    tweenBar = FlxTween.tween(volBar, {y: topoVisivel}, velocidadeTween, {ease: FlxEase.cubeOut});
}

function hideVolumeTray() {
    // Tween de saída (Sobe de volta para fora da tela)
    tweenBG = FlxTween.tween(volBG, {y: topoEscondido}, velocidadeTween, {
        ease: FlxEase.cubeIn, 
        onComplete: function(twn:FlxTween) {
            isShowing = false; // Permite reiniciar o ciclo na próxima alteração
        }
    });
    tweenBar = FlxTween.tween(volBar, {y: topoEscondido}, velocidadeTween, {ease: FlxEase.cubeIn});
}