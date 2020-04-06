(function ($) {
	'use strict';
	document.addEventListener('DOMContentLoaded', function () {
		FastClick.attach(document.body);
	});

	$(function () {
		// Create tour
		$('.j-mv360tour-public').each(function (i, e) {
			new MV360TourPublic($(e));
		});

	});
})(jQuery);

function MV360TourPublic($el) {
	this.$el = $el;
	this.embed = this.$el.data('embed');
	this.$embedEl = '';
	if (this.embed) {
		this.$embedEl = this.$el.parent();
	}
	this.initSlickMenu = false;
	this.$wrapper = this.$el.parent();

	// this.data = JSON.parse($el.find('.j-mv360tour-public-data').html());
	this.dataDefault = JSON.parse($el.find('[data-default="1"]').html());
	this.options = JSON.parse($el.find('.j-mv360tour-public-opt').html());

	this.initVideo();

	var opt = {
		controls: {
			//scrollZoom: true,
			mouseViewMode: 'drag',
		},
	};
	if (this.options.zoomScroll) {
		opt.controls.scrollZoom = false;
	}
	this.viewer = new Marzipano.Viewer(this.$el.get(0), opt);

	// ZOOM AND MOVE CONTROLS
	if (this.options.zoom || this.options.move || this.options.gyro) {
		this.controls = this.viewer.controls();
		this.deviceOrientationControlMethod = new MV360TourPublicDeviceOrientationControlMethod();
		this.controls.registerMethod('deviceOrientation', this.deviceOrientationControlMethod);

		this.velocity = 0.7;
		this.friction = 3;

		this.$controls = jQuery('<div class="mv360tour-controls"></div>');
		this.$el.append(this.$controls);

		this.createMoveControls();
		if (this.options.gyro) { this.createGyroscopeControls(); }
		this.createZoomControls();
	}

	// if (this.options.autostart) {
	// 	this.autorotate = Marzipano.autorotate({
	// 		yawSpeed: 0.03,
	// 		targetPitch: 0,
	// 		targetFov: Math.PI / 2
	// 	});
	// 	this.startAutorotate();
	// }

	this.autorotate = Marzipano.autorotate({
		yawSpeed: 0.03,
		targetPitch: 0,
		targetFov: Math.PI / 2
	});
	this.startAutorotate();


	this.addSceneTitle();

	this.createFirstScene();

	if (!this.options.hideMenu) {
		this.addMenu();
	}

	// this.createFullscreenControl();
	// this.createCloseLightBoxControl();

	jQuery(document).on('fullscreenchange mozfullscreenchange webkitfullscreenchange msfullscreenchange', this.changeFullscreenEvent.bind(this));
};

MV360TourPublic.prototype.initVideo = function () {
	this.video = document.createElement('video');

	this.video.controls = true;
	// this.video.crossOrigin = 'anonymous';

	this.video.autoplay = false;
	this.video.loop = true;

	// Prevent the video from going full screen on iOS.
	this.video.playsInline = true;
	this.video.webkitPlaysInline = true;

	jQuery(this.video).on('timeupdate', this.updateProgressBar.bind(this));
	jQuery(this.video).on('timeupdate', this.updateCurrentTimeIndicator.bind(this));
	jQuery(this.video).on('loadedmetadata', this.updateDurationIndicator.bind(this));

	this.$controls = jQuery('<div class="mv360tour-video-controls j-mv360tour-video-controls"></div>');

	this.$progressFillElement = jQuery('<div class="mv360tour-video-controls-progress-fill"></div>');
	this.$progressBackgroundElement = jQuery('<div class="mv360tour-video-controls-progress-background"></div>');
	this.$progressBackgroundElement.append(this.$progressFillElement);

	this.$currentTimeIndicatorElement = jQuery('<div class="mv360tour-video-controls-current-time-indicator">0:00</div>');
	this.$durationIndicatorElement = jQuery('<div class="mv360tour-video-controls-duration-indicator">0:00</div>');
	this.$indicators = jQuery('<div class="mv360tour-video-controls-indicators"></div>');
	this.$indicators.append(this.$currentTimeIndicatorElement, this.$durationIndicatorElement);

	this.$playPauseElement = jQuery('<div class="mv360tour-video-controls-play-pause"></div>');
	this.$playMobile = jQuery('<div class="mv360tour-video-controls-play-mobile"><span></span></div>');

	this.$muteElement = jQuery('<div class="mv360tour-video-controls-mute"></div>');

	this.$controls.append(this.$progressBackgroundElement, this.$indicators, this.$playPauseElement, this.$muteElement);
	this.$el.append(this.$controls, this.$playMobile);

	this.$playPauseElement.bind('click', this.playPause.bind(this));
	this.$playMobile.bind('click', this.playPause.bind(this));
	this.$muteElement.bind('click', this.mute.bind(this));
	this.$progressBackgroundElement.bind('click', this.progressBackground.bind(this));
};

MV360TourPublic.prototype.isTouch = function () {
	return 'ontouchstart' in window || navigator.maxTouchPoints;
};


MV360TourPublic.prototype.isMobileOs = function () {
	var check = false;
	if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
		check = true;
	}
	return check;
};

MV360TourPublic.prototype.addSceneTitle = function () {
	this.$titleScene = jQuery('<div class="mv360tour-title-scene"></div>');
	this.$titleSceneLogo = jQuery('<img class="vt-property-logo" src=' + vtPropertyLogo + '>');
	this.$titleSeparator = jQuery('<svg class="vt-separator" width="1px" height="33px" viewBox="0 0 1 33" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Desktop-/-Student" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Desktop-Virtual-Tour---SYD-03-v2" transform="translate(-630.000000, -24.000000)" fill="#FFFFFF"><rect id="Rectangle" x="630" y="24" width="1" height="33"></rect></g></g></svg>')
	this.$titleSceneText = jQuery('<span></span>');
	this.$titleSceneOverlay = jQuery('<div class="start-overlay" ondragstart="removeOverlay()" draggable="true" onclick="removeOverlay()"><div class="drag-img-overlay"></div></div>');
	this.$titleSceneRoomSize = jQuery('<div></div>');


	if (vtColor) {
		this.$titleScene.css('background-color', vtColor);
	}
	if (this.options.primaryColor) {
		this.$titleScene.css('color', this.options.primaryColor);
	}
	this.$el.append(this.$titleScene);
	this.$titleScene.append(this.$titleSceneLogo);
	this.$titleScene.append(this.$titleSeparator);
	this.$titleScene.append(this.$titleSceneText);
	this.$titleScene.append(this.$titleSceneRoomSize);
	this.$titleScene.append(this.$titleSceneOverlay);
};

MV360TourPublic.prototype.addMenu = function () {
	this.$menuBtn = jQuery('<a href="#" class="mv360tour-menu-btn"><svg width="39px" height="30px" viewBox="0 0 39 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><title>icon/hamburger-menu</title><g id="Desktop-/-Student" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Desktop-Virtual-Tour---SYD-03-v2" transform="translate(-30.000000, -25.000000)" fill="#FFFFFF" fill-rule="nonzero"><g id="icon/hamburger-menu" transform="translate(30.000000, 25.000000)"><polygon id="Rectangle-7" points="0 25.2631579 39 25.2631579 39 30 0 30"></polygon><polygon id="Rectangle-7-Copy" points="0 12.6315789 39 12.6315789 39 17.3684211 0 17.3684211"></polygon><polygon id="Rectangle-7-Copy-2" points="0 0 39 0 39 4.73684211 0 4.73684211"></polygon></g></g></g></svg></a>');

	this.$menuBtnClose = jQuery('<div id="gradient-bar" style="background: ' + vtColor + '; background: linear-gradient(0deg, rgba(0,0,0,0) 0%, ' + vtColor + ')"></div><a href="#" class="mv360tour-menu-btn mv360tour-menu-btn-close"><svg width="31px" height="32px" viewBox="0 0 31 32" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Desktop-/-Student" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Desktop-Virtual-Tour---SYD-03-v2" transform="translate(-1375.000000, -24.000000)" fill="#FFFFFF"><g id="icon/close-white" transform="translate(1370.000000, 20.000000)"><g id="Group" transform="translate(20.277778, 20.000000) rotate(45.000000) translate(-20.277778, -20.000000) "><rect id="Rectangle-13" fill-rule="nonzero" x="18.8888889" y="0" width="2.77777778" height="40"></rect><polygon id="Rectangle-13" fill-rule="nonzero" transform="translate(20.277778, 20.000000) rotate(90.000000) translate(-20.277778, -20.000000) " points="18.8888889 -1.33226763e-14 21.6666667 -1.33226763e-14 21.6666667 40 18.8888889 40"></polygon></g></g></g></g></svg></a>');

	this.$menuBtn.bind('click', this.toggleMenu.bind(this));
	this.$menuBtnClose.bind('click', this.toggleMenu.bind(this));

	if (this.options.primaryColor) {
		this.$menuBtn.find('svg').css('fill', this.options.primaryColor);
		this.$menuBtnClose.find('svg').css('fill', this.options.primaryColor);
	}
	this.$titleScene.append(this.$menuBtn);

	this.$menuOverlay = jQuery('<div class="mv360tour-menu"></div>');

	if (this.options.primaryColor) {
		this.$menuOverlay.css('color', this.options.primaryColor);
	}

	if (vtColor) {
		this.$menuOverlay.css('background-color', vtColor);
	}

	this.$menuOverlay.append(this.$menuBtnClose);

	this.$menuList = jQuery('<ul></ul>');
	this.$menuListLogo = jQuery('<img class="vt-menu-list-property-logo" src=' + vtPropertyLogo + '>');
	this.$menuwrapper = jQuery('<div class="mv360tour-menu-wrapper"></div>');
	this.$menuOverlay.append(this.$menuwrapper);
	this.$menuwrapper.append(this.$menuListLogo);
	this.$menuwrapper.append(this.$menuList);


	jQuery('.j-mv360tour-public-data').each(function (i, e) {
		var $e = jQuery(e);
		var scene = JSON.parse($e.html());

		console.log('Scene: ', scene)

		var dataScene = {
			id: scene.id,
		};
		if (scene.position) {
			dataScene.position = scene.position;
		}
		var $list_el = jQuery('<li data-scene=\'' + JSON.stringify(dataScene) + '\'>' + scene.title + '</li>');
		if (i == 0) {
			$list_el.addClass('vt-active')
		}
		if (scene.hideInMenu) {
			$list_el.addClass('list-item-hidden')
		}
		if (this.options.menu) {
			var $list_el = jQuery('<li data-scene=\'' + JSON.stringify(dataScene) + '\'><div><span>' + scene.title + '</span><img src="' + scene.thumb + '"></div></li>');
			if (this.options.secondaryColor) {
				$list_el.find('span').css('color', this.options.secondaryColor);
			}

			if (this.options.primaryColor) {
				$list_el.find('span').css('background-color', this.options.primaryColor);
				var rgba = $list_el.find('span').css('background-color').replace('rgb', 'rgba').replace(')', ',.7)');
				$list_el.find('span').css('background-color', rgba);
			}
		}
		$list_el.bind('click', this.changeScene.bind(this));
		this.$menuList.append($list_el);
		i++;
	}.bind(this));

	this.$el.prepend(this.$menuOverlay);

	if (this.options.menu) {
		this.$menuList.on('init', function () {
			if (this.options.primaryColor) {
				this.$menuList.find('.slick-arrow').css('background-color', this.options.primaryColor);
			}
			if (this.options.secondaryColor) {
				this.$menuList.find('.slick-arrow').css('color', this.options.secondaryColor);
			}
			this.initSlickMenu = true;
		}.bind(this));

		if (this.embed) {
			jQuery(window).bind('resize', this.slickMenuEmbed.bind(this));
			this.slickMenuEmbed();
		} else {
			this.$menuList.slick({
				slidesToShow: 3,
				slidesToScroll: 1,
				arrow: true,
				responsive: [
					{
						breakpoint: 980,
						settings: {
							slidesToShow: 2,
						}
					},
					{
						breakpoint: 600,
						settings: {
							slidesToShow: 1,
						}
					}
				]
			});
		}
	}
};

MV360TourPublic.prototype.slickMenuEmbed = function () {
	if (this.initSlickMenu) {
		this.$menuList.slick('unslick');
	}

	if (this.$wrapper.width() <= 600) {
		this.$menuList.slick({
			slidesToShow: 1,
			slidesToScroll: 1,
			arrow: true,
		});
	} else if (this.$wrapper.width() <= 980) {
		this.$menuList.slick({
			slidesToShow: 2,
			slidesToScroll: 1,
			arrow: true,
		});
	} else {
		this.$menuList.slick({
			slidesToShow: 3,
			slidesToScroll: 1,
			arrow: true,
		});
	}
	this.$menuList.slick('setPosition');
};

MV360TourPublic.prototype.toggleMenu = function (e) {
	if (e) {
		e.preventDefault();
	}

	if (this.$menuOverlay.hasClass('is-open')) {
		this.$menuOverlay.removeClass('is-open');
		setTimeout(function () {
			this.$menuOverlay.removeClass('is-front');
		}.bind(this), 400);
	} else {
		this.$menuOverlay.addClass('is-front');
		if (this.options.menu) {
			this.$menuList.slick('setPosition');
		}

		setTimeout(function () {
			this.$menuOverlay.addClass('is-open');
		}.bind(this), 10);
	}
};

MV360TourPublic.prototype.startAutorotate = function () {
	// if (this.options.autostart) {
	// 	this.viewer.startMovement(this.autorotate);
	// 	this.viewer.setIdleMovement(3000, this.autorotate);
	// }

	this.viewer.startMovement(this.autorotate);
	this.viewer.setIdleMovement(1000, this.autorotate);

};

MV360TourPublic.prototype.stopAutorotate = function () {
	// if (this.options.autostart) {
	// 	this.viewer.stopMovement();
	// 	this.viewer.setIdleMovement(Infinity);
	// }

	this.viewer.stopMovement();
	this.viewer.setIdleMovement(Infinity);

};

MV360TourPublic.prototype.stopEventsPropagation = function (element, eventList) {
	var eventList = ['touchstart', 'touchmove', 'touchend', 'touchcancel', 'wheel', 'mousewheel', 'scroll'];
	for (var i = 0; i < eventList.length; i++) {
		element.addEventListener(eventList[i], function (event) {
			event.stopPropagation();
		});
	}
};

MV360TourPublic.prototype.createZoomControls = function () {
	this.$zoomIn = jQuery('<span class="mv360tour-zoom-in"></span>');
	this.$zoomOut = jQuery('<span class="mv360tour-zoom-out"></span>');

	if (this.options.secondaryColor) {
		this.$zoomOut.css('background-color', this.options.secondaryColor);
		this.$zoomIn.css('background-color', this.options.secondaryColor);
	}

	if (this.options.primaryColor) {
		this.$zoomOut.css('color', this.options.primaryColor);
		this.$zoomIn.css('color', this.options.primaryColor);
	}

	this.controls.registerMethod('inElement', new Marzipano.ElementPressControlMethod(this.$zoomIn.get(0), 'zoom', -this.velocity, this.friction), true);
	this.controls.registerMethod('outElement', new Marzipano.ElementPressControlMethod(this.$zoomOut.get(0), 'zoom', this.velocity, this.friction), true);

	this.$controls.append(this.$zoomIn);
	this.$controls.append(this.$zoomOut);
};

MV360TourPublic.prototype.changeFullscreenEvent = function (e) {
	if ((window.fullScreen) || (window.innerWidth == screen.width && window.innerHeight == screen.height)) {
		this.$fullScreen.addClass('is-open');
	} else {
		this.$fullScreen.removeClass('is-open');
	}
};

MV360TourPublic.prototype.createFullscreenControl = function () {
	var color = '#fff';
	if (this.options.primaryColor) {
		color = this.options.primaryColor;
	}
	this.$fullScreen = jQuery('<span class="mv360tour-fullscreen"><svg class="mv360tour-fullscreen--close" style="fill:' + color + ';" version="1.1" xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><path d="M32 0h-13l5 5-6 6 3 3 6-6 5 5z"></path><path d="M32 32v-13l-5 5-6-6-3 3 6 6-5 5z"></path><path d="M0 32h13l-5-5 6-6-3-3-6 6-5-5z"></path><path d="M0 0v13l5-5 6 6 3-3-6-6 5-5z"></path></svg><svg class="mv360tour-fullscreen--open" style="fill:' + color + ';" version="1.1" xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><path d="M18 14h13l-5-5 6-6-3-3-6 6-5-5z"></path><path d="M18 18v13l5-5 6 6 3-3-6-6 5-5z"></path><path d="M14 18h-13l5 5-6 6 3 3 6-6 5 5z"></path><path d="M14 14v-13l-5 5-6-6-3 3 6 6-5 5z"></path></svg></span>');
	this.$fullScreen.bind('click', this.toggleFullscreen.bind(this));
	this.$titleScene.append(this.$fullScreen);
};

MV360TourPublic.prototype.createCloseLightBoxControl = function () {
	var color = '#fff';
	if (this.options.primaryColor) {
		color = this.options.primaryColor;
	}
	this.$fullScreen = jQuery('<button uk-close class="uk-lightbox-toolbar-icon uk-close-large uk-close uk-icon" style="position: absolute; top: 20px; right: 20px"><svg width="31px" height="32px" viewBox="0 0 31 32" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><g id="Desktop-/-Student" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Desktop-Virtual-Tour---SYD-03-v2" transform="translate(-1375.000000, -24.000000)" fill="#FFFFFF"><g id="icon/close-white" transform="translate(1370.000000, 20.000000)"><g id="Group" transform="translate(20.277778, 20.000000) rotate(45.000000) translate(-20.277778, -20.000000) "><rect id="Rectangle-13" fill-rule="nonzero" x="18.8888889" y="0" width="2.77777778" height="40"></rect><polygon id="Rectangle-13" fill-rule="nonzero" transform="translate(20.277778, 20.000000) rotate(90.000000) translate(-20.277778, -20.000000) " points="18.8888889 -1.33226763e-14 21.6666667 -1.33226763e-14 21.6666667 40 18.8888889 40"></polygon></g></g></g></g></svg></button>');
	this.$fullScreen.bind('click', this.closeVirtualTour.bind(this));
	this.$titleScene.append(this.$fullScreen);
};

MV360TourPublic.prototype.toggleFullscreen = function () {
	if (!this.fullScreen) {
		if (this.$el.get(0).requestFullscreen) {
			this.$el.get(0).requestFullscreen();
		} else if (this.$el.get(0).mozRequestFullScreen) { /* Firefox */
			this.$el.get(0).mozRequestFullScreen();
		} else if (this.$el.get(0).webkitRequestFullscreen) { /* Chrome, Safari and Opera */
			this.$el.get(0).webkitRequestFullscreen();
		} else if (this.$el.get(0).msRequestFullscreen) { /* IE/Edge */
			this.$el.get(0).msRequestFullscreen();
		}
		this.fullScreen = 1;
	} else {
		if (document.exitFullscreen) {
			document.exitFullscreen();
		} else if (document.mozCancelFullScreen) { /* Firefox */
			document.mozCancelFullScreen();
		} else if (document.webkitExitFullscreen) { /* Chrome, Safari and Opera */
			document.webkitExitFullscreen();
		} else if (document.msExitFullscreen) { /* IE/Edge */
			document.msExitFullscreen();
		}
		this.fullScreen = 0;
	}
}

MV360TourPublic.prototype.closeVirtualTour = function () {


}

MV360TourPublic.prototype.createGyroscopeControls = function () {
	var bg = '#000';
	if (this.options.secondaryColor) {
		bg = this.options.secondaryColor;
	}

	var color = '#fff';
	if (this.options.primaryColor) {
		color = this.options.primaryColor;
	}
	this.$gyroscope = jQuery('<span style="background-color:' + bg + ';" class="mv360tour-gyro"><svg style="fill:' + color + ';" version="1.1" xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32"><path d="M16 0c-8.837 0-16 7.163-16 16s7.163 16 16 16 16-7.163 16-16-7.163-16-16-16zM3 16c0-7.18 5.82-13 13-13 3.424 0 6.538 1.325 8.86 3.488l-12.86 5.512-5.512 12.86c-2.164-2.322-3.488-5.436-3.488-8.86zM18.286 18.286l-8.003 3.43 3.43-8.003 4.573 4.573zM16 29c-3.424 0-6.539-1.325-8.86-3.488l12.86-5.512 5.512-12.86c2.164 2.322 3.488 5.436 3.488 8.86 0 7.18-5.82 13-13 13z"></path></svg></span>');

	this.$gyroscope.bind('click', this.toggleGyro.bind(this));
	this.$controls.append(this.$gyroscope);
};

MV360TourPublic.prototype.toggleGyro = function () {
	if (!this.gyroEnabled) {
		this.deviceOrientationControlMethod.getPitch(function (err, pitch) {
			if (!err) {
				var view = this.scenes[this.getSceneOffset(this.activeSceneId)].scene._view;
				var pos = {
					fov: view._fov,
					pitch: view._pitch,
					yaw: view._yaw,
				};
				pos.pitch = pitch;
				this.scenes[this.getSceneOffset(this.activeSceneId)].scene.lookTo(pos, { transitionDuration: 0 });
			}
		}.bind(this));
		this.controls.enableMethod('deviceOrientation');
		this.gyroEnabled = true;
	} else {
		this.controls.disableMethod('deviceOrientation');
		this.gyroEnabled = false;
	}
};

MV360TourPublic.prototype.createMoveControls = function () {
	this.$arrowTop = jQuery('<span class="mv360tour-arrow mv360tour-arrow--top"></span>');
	this.$arrowBottom = jQuery('<span class="mv360tour-arrow mv360tour-arrow--bottom"></span>');
	this.$arrowLeft = jQuery('<span class="mv360tour-arrow mv360tour-arrow--left"></span>');
	this.$arrowRight = jQuery('<span class="mv360tour-arrow mv360tour-arrow--right"></span>');

	if (this.options.secondaryColor) {
		this.$arrowTop.css('background-color', this.options.secondaryColor);
		this.$arrowBottom.css('background-color', this.options.secondaryColor);
		this.$arrowLeft.css('background-color', this.options.secondaryColor);
		this.$arrowRight.css('background-color', this.options.secondaryColor);
	}

	if (this.options.primaryColor) {
		this.$arrowTop.css('color', this.options.primaryColor);
		this.$arrowBottom.css('color', this.options.primaryColor);
		this.$arrowLeft.css('color', this.options.primaryColor);
		this.$arrowRight.css('color', this.options.primaryColor);
	}

	this.controls.registerMethod('upElement', new Marzipano.ElementPressControlMethod(this.$arrowTop.get(0), 'y', -this.velocity, this.friction), true);
	this.controls.registerMethod('downElement', new Marzipano.ElementPressControlMethod(this.$arrowBottom.get(0), 'y', this.velocity, this.friction), true);
	this.controls.registerMethod('leftElement', new Marzipano.ElementPressControlMethod(this.$arrowLeft.get(0), 'x', -this.velocity, this.friction), true);
	this.controls.registerMethod('rightElement', new Marzipano.ElementPressControlMethod(this.$arrowRight.get(0), 'x', this.velocity, this.friction), true);


	this.$controls.append(this.$arrowLeft);
	this.$controls.append(this.$arrowRight);
	this.$controls.append(this.$arrowBottom);
	this.$controls.append(this.$arrowTop);
};

MV360TourPublic.prototype.getDefaultSceneOffset = function () {
	var i = 0;
	var offset;
	while (i < this.scenes.length) {
		if (this.scenes[i].data.default) {
			offset = i;
		}
		i++;
	}
	return offset;
};

MV360TourPublic.prototype.getSceneOffset = function (id) {
	var i = 0;
	var offset;
	while (i < this.scenes.length) {
		if (this.scenes[i].data.id == id) {
			offset = i;
		}
		i++;
	}
	return offset;
};

MV360TourPublic.prototype.createFirstScene = function () {
	var scene = this.createScene(this.dataDefault);

	this.changeScene(null, scene);

	if (this.dataDefault.img && this.dataDefault.img.src) {
		this.scene = this.createSceneImage(this.dataDefault);
	} else {
		this.scene = this.createSceneVideo(this.dataDefault);
	}
};

MV360TourPublic.prototype.createScene = function (data) {
	var scene = '';
	if (data.img && data.img.src) {
		scene = this.createSceneImage(data);
	} else {
		scene = this.createSceneVideo(data);
	}

	return scene;
};

MV360TourPublic.prototype.getScene = function (id) {
	if (typeof (id) == 'object') {
		id = id.id;
	}
	return this.createScene(JSON.parse(this.$el.find('[data-scene="' + id + '"]').html()));
};

MV360TourPublic.prototype.createSceneImage = function (data) {
	var source = Marzipano.ImageUrlSource.fromString(data.img.src);
	var geometry = new Marzipano.EquirectGeometry([{ width: data.img.width }]);
	var limiter = Marzipano.RectilinearView.limit.traditional(2600, 120 * Math.PI / 180);

	var view = new Marzipano.RectilinearView(data.position, limiter);

	var scene = this.viewer.createScene({
		source: source,
		geometry: geometry,
		view: view,
		pinFirstLevel: true
	});

	var i = 0;
	if (data.hotspots) {
		while (i < data.hotspots.length) {
			var hotspot = data.hotspots[i];
			var element = this.createHotspotHtml(hotspot);
			scene.hotspotContainer().createHotspot(element, { yaw: hotspot.position.yaw, pitch: hotspot.position.pitch });
			i++;
		}
	}

	return {
		data: data,
		scene: scene,
		view: view
	};
};

MV360TourPublic.prototype.createSceneVideo = function (data) {
	var asset = new VideoAsset();
	var source = new Marzipano.SingleAssetSource(asset);
	var limiter = Marzipano.RectilinearView.limit.traditional(2600, 120 * Math.PI / 180);

	var view = new Marzipano.RectilinearView(data.position, limiter);

	var scene = this.viewer.createScene({
		source: source,
		geometry: new Marzipano.EquirectGeometry([{ width: 1 }]),
		view: view,
		pinFirstLevel: true,
	});

	var i = 0;
	if (data.hotspots) {
		while (i < data.hotspots.length) {
			var hotspot = data.hotspots[i];
			var element = this.createHotspotHtml(hotspot);
			scene.hotspotContainer().createHotspot(element, { yaw: hotspot.position.yaw, pitch: hotspot.position.pitch });
			i++;
		}
	}

	data.video.asset = asset;
	return {
		data: data,
		scene: scene,
		view: view
	};
};

MV360TourPublic.prototype.createHotspotHtml = function (hotspot) {

	var $el = jQuery('<div></div>');
	// RIMUOVO GLI EVENTI DI MARZIPANO (PER SCROLL ECC.)
	this.stopEventsPropagation($el.get(0));

	if (hotspot.icon && hotspot.icon.url) {
		$el.addClass('mv360tour-hotspot-icon');
		$el.css('background-image', 'url(' + hotspot.icon.url + ')');

		if (hotspot.icon.width) {
			$el.css('width', hotspot.icon.width + 'px');
			$el.css('margin-left', hotspot.icon.width / 2 * -1 + 'px');
		}
		if (hotspot.icon.height) {
			$el.css('height', hotspot.icon.height + 'px');
			$el.css('margin-top', hotspot.icon.height / 2 * -1 + 'px');
		}
	} else {
		$el.append('<div class="lds-ripple"><div></div><div></div></div>');
		$el.addClass('mv360tour-hotspot');
	}

	switch (hotspot.type) {
		case 'image':
			var $container = jQuery('<div class="mv360tour-hotspot__container mv360tour-hotspot__container--img"></div>');
			if (hotspot.title) {
				var $title = jQuery('<div class="mv360tour-hotspot__title"><span>' + hotspot.title + '</span></div>');
				if (hotspot.popup && hotspot.popup.titleColor) {
					$title.css('color', hotspot.popup.titleColor);
				}
				$container.append($title);
			}
			$container.append('<img src="' + hotspot.image + '">');
			if (hotspot.popup && hotspot.popup.titleBgColor) {
				if ($title) {
					$title.find('span').css('background-color', hotspot.popup.titleBgColor);
					var rgba = $title.find('span').css('background-color').replace('rgb', 'rgba').replace(')', ',.7)');
					$title.find('span').css('background-color', rgba);
				}
			}
			$el.append($container);

			var $clickOffset = jQuery('<span class="mv360tour-hotspot__click"></span>');
			$el.append($clickOffset);
			$clickOffset.bind('click touchend', this.toggleHotspot.bind(this));
			break;

		case 'text':
			var $container = jQuery('<div class="mv360tour-hotspot__container mv360tour-hotspot__container--text"></div>');
			if (hotspot.title) {
				// HTML DECODE
				var title = jQuery('<textarea />').html(hotspot.title).text();
				var $title = jQuery('<div class="mv360tour-hotspot__title mv360tour-hotspot__title--text"><span>' + title + '</span></div>');
				if (hotspot.popup && hotspot.popup.titleColor) {
					$title.css('color', hotspot.popup.titleColor);
				}
				$container.append($title);
			}
			if (hotspot.text) {
				// HTML DECODE
				var text = jQuery('<textarea />').html(hotspot.text).text();
				$container.append('<div class="mv360tour-hotspot__container__text">' + text + '</div>');
			}
			$el.append($container);

			var $clickOffset = jQuery('<span class="mv360tour-hotspot__click"></span>');
			$el.append($clickOffset);
			$clickOffset.bind('click touchend', this.toggleHotspot.bind(this));

			break;

		case 'link':
			var $container = jQuery('<div class="mv360tour-hotspot__container mv360tour-hotspot__container--link"></div>');
			var $clickOffset = jQuery('<a target="_blank" href="' + hotspot.link + '" class="mv360tour-hotspot__click"></a>');
			$el.append($clickOffset);
			break;

		case 'video':
			var $container = jQuery('<div class="mv360tour-hotspot__container mv360tour-hotspot__container--video"></div>');
			if (hotspot.title) {
				var $title = jQuery('<div class="mv360tour-hotspot__title mv360tour-hotspot__title--text"><span>' + hotspot.title + '</span></div>');
				if (hotspot.popup && hotspot.popup.titleColor) {
					$title.css('color', hotspot.popup.titleColor);
				}
				$container.append($title);
			}
			if (hotspot.url) {
				$container.append('<div class="mv360tour-hotspot__container__video">' + this.getVideoEmbed(hotspot.url) + '</div>');
			}
			$el.append($container);

			var $clickOffset = jQuery('<span class="mv360tour-hotspot__click"></span>');
			$el.append($clickOffset);
			$clickOffset.bind('click touchend', this.toggleHotspot.bind(this));

			break;

		case 'scene':
			var $container = jQuery('<div class="mv360tour-hotspot__container mv360tour-hotspot__container--scene"></div>');
			if (hotspot.title) {
				var $title = jQuery('<div class="mv360tour-hotspot__title mv360tour-hotspot__title--scene"><span class="border-helper">' + hotspot.title + '</span></div>');
				$container = jQuery('<div class="mv360tour-hotspot__container mv360tour-hotspot__container--scene" data-scene=\'' + JSON.stringify(hotspot.scene) + '\'></div>');
				if (hotspot.popup && hotspot.popup.titleColor) {
					$title.css('color', hotspot.popup.titleColor);
				}
				$container.append($title);
			}
			$el.addClass('custom-scene-icon');
			$el.append($container);

			var $clickOffset = jQuery('<span class="mv360tour-hotspot__click" data-scene=\'' + JSON.stringify(hotspot.scene) + '\'></span>');
			$el.append($clickOffset);
			$clickOffset.bind('click touchend', this.toggleHotspot.bind(this));
			if (!this.isTouch()) {
				if ($title) {
					$container.bind('click touchend', this.changeScene.bind(this));
				} else {
					$clickOffset.bind('click touchend', this.changeScene.bind(this));
				}
			} else {
				$clickOffset.bind('click touchend', this.changeScene.bind(this));
			}

			break;
		default:
	}
	// Larghezza hotspot
	var paddingLeftRight = 40;
	if (hotspot.popup && hotspot.popup.width) {
		$container.css('width', parseInt(hotspot.popup.width) + paddingLeftRight + 'px');
	}

	// LARGHEZZA MASSIMA HOTSPOT CON EMBED
	if (this.embed) {
		$container.css('max-width', parseInt(this.$embedEl.width()) - paddingLeftRight + 'px');
	}

	$arrow = jQuery('<span class="mv360tour-hotspot__container__arrow"></span>')
	$arrowShadow = jQuery('<span class="mv360tour-hotspot__container__arrow-shadow"></span>')
	// Colori hotspot - HotSpot link non ha un container
	if (hotspot.popup && hotspot.popup.titleBgColor) {
		$container.css('background-color', hotspot.popup.titleBgColor);
		$container.css('color', hotspot.popup.titleBgColor);
		$arrow.css('border-top-color', hotspot.popup.titleBgColor);
	}
	$container.append($arrow);
	$container.append($arrowShadow);

	if (this.embed) {
		jQuery(window).bind('resize', this.resizeEmbedContainerHotspot.bind(this));
		this.resizeEmbedContainerHotspot();
	}
	return $el.get(0);
};

MV360TourPublic.prototype.resizeEmbedContainerHotspot = function (e) {
	this.$el.find('.mv360tour-hotspot__container').each(function (i, e) {
		jQuery(e).css('max-width', (this.$wrapper.width() - 20) + 'px');
	}.bind(this));
};

MV360TourPublic.prototype.closeHotspotMobile = function (e) {
	e.preventDefault();
	var $e = jQuery(e.currentTarget);
	$e.parent().remove();
	jQuery('.mv360tour-hotspot').focus();
};

MV360TourPublic.prototype.toggleHotspot = function (e) {
	e.preventDefault();

	var $e = jQuery(e.currentTarget).parent();

	if (this.isTouch()) {
		var $content = $e.find('.mv360tour-hotspot__container').clone();
		if (!$content.hasClass('mv360tour-hotspot__container--scene')) {
			$content.addClass('mv360tour-hotspot__container--body');
			var $closeHotspot = jQuery('<a href="#" class="j-mv360tour-hotspot-body-remove mv360tour-hotspot__container__remove"><span class="mv360tour-hotspot__container__remove__horizontal"></span><span class="mv360tour-hotspot__container__remove__vertical"></span></a>');
			if (this.options.secondaryColor) {
				$closeHotspot.find('span').css('background-color', this.options.secondaryColor);
			}
			$closeHotspot.bind('click', this.closeHotspotMobile.bind(this));
			$content.prepend($closeHotspot);
			this.$el.append($content);
		}
	} else {
		if ($e.hasClass('is-open')) {
			this.startAutorotate();
			$e.removeClass('is-open');
			setTimeout(function () {
				$e.removeClass('is-front');
			}, 400);
		} else {
			// this.stopAutorotate();
			$e.addClass('is-front');
			setTimeout(function () {
				$e.addClass('is-open');
			}, 10);

			// this.viewer.lookTo(this.viewer._currentScene._view.screenToCoordinates({ x: $e.offset().left - this.$el.offset().left, y: $e.offset().top - this.$el.offset().top - (this.$el.height() / 4) }));
		}
	}
};

MV360TourPublic.prototype.getVideoEmbed = function (url) {
	var retUrl = '';
	var iframeMarkup = '';
	if (url.indexOf('vimeo') !== -1) {
		var vimeoRegex = /(?:vimeo)\.com.*(?:videos|video|channels|)\/([\d]+)/i;
		var parsed = url.match(vimeoRegex);
		if (parsed && parsed[1]) {
			retUrl = '//player.vimeo.com/video/' + parsed[1];
		}
	} else if (url.indexOf('youtube') !== -1) {
		var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
		var match = url.match(regExp);

		if (match && match[2].length == 11) {
			var id = match[2];
			retUrl = '//www.youtube.com/embed/' + id;
		}
	}

	if (retUrl) {
		iframeMarkup = '<iframe src="' + retUrl + '" frameborder="0" allowfullscreen></iframe>';
	}

	return iframeMarkup;
};

MV360TourPublic.prototype.closeAllHotspot = function () {
	this.$el.find('.mv360tour-hotspot').removeClass('is-open');
	this.$el.find('.mv360tour-hotspot').removeClass('is-front');
	this.$el.find('.mv360tour-hotspot-icon').removeClass('is-front');
	this.$el.find('.mv360tour-hotspot-icon').removeClass('is-open');
};

MV360TourPublic.prototype.changeScene = function (e, newScene) {


	this.$controls.removeClass('is-visible');
	this.video.src = '';
	var scene = '';
	if (e) {
		e.preventDefault();
		var allSceneLinks = document.querySelectorAll('li[data-scene]');
		jQuery(allSceneLinks).removeClass('vt-active');
		e.currentTarget.classList.add('vt-active');
		scene = jQuery(e.currentTarget).data('scene');

		scene = this.getScene(jQuery(e.currentTarget).data('scene'));
	} else {
		scene = newScene;
	}

	// IF THE SCENE IS THE SAME, LOOK AT THE NEW POSITION
	if (this.activeScene == scene.data.id) {
		if (scene.data.position && scene.data.position.yaw && scene.data.position.pitch) {
			this.viewer.lookTo(scene.data.position);
		}
	} else {
		this.closeAllHotspot();
		scene.scene.switchTo();
		this.activeScene = scene.data.id;
		this.$titleSceneText.html(scene.data.title);
		if (scene && scene.data && scene.data.roomSize) {
			this.$titleSceneRoomSize.html('')
			this.$titleSceneRoomSize.append('<div class="room-size"><div class="room-size__icon"><svg width="40px" height="33px" viewBox="0 0 40 33" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><polygon id="path-1" points="0.00585365854 0.0191219512 39.9611707 0.0191219512 39.9611707 32 0.00585365854 32"></polygon></defs><g id="Desktop-/-Student" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"><g id="Desktop-Virtual-Tour---SYD-03-v2" transform="translate(-45.000000, -120.000000)"><g id="Padding-Group-10" transform="translate(30.000000, 110.000000)"><g id="Group-4-Copy" transform="translate(15.000000, 7.000000)"><g id="icon/bed-white"><g id="045-single-bed-02" transform="translate(0.000000, 3.888889)"><g id="Group-3"><mask id="mask-2" fill="white"><use xlink:href="#path-1"></use></mask><g id="Clip-2"></g><path d="M32.1089756,30.6498537 L35.0438049,30.6498537 L35.0438049,27.7146341 L32.1089756,27.7146341 L32.1089756,30.6498537 Z M4.91726829,30.6498537 L7.85209756,30.6498537 L7.85209756,27.7146341 L4.91726829,27.7146341 L4.91726829,30.6498537 Z M39.2858537,20.4531707 L38.7553171,20.4531707 L38.7553171,17.4489756 C38.7553171,16.1463415 37.8940488,15.0411707 36.7115122,14.6726829 L36.7115122,3.3022439 C36.7115122,1.492 35.2385366,0.0191219512 33.4283902,0.0191219512 L6.53239024,0.0191219512 C4.72214634,0.0191219512 3.24926829,1.49170732 3.24926829,3.3022439 L3.24926829,7.62546341 C3.24926829,7.99814634 3.55141463,8.30039024 3.92458537,8.30039024 C4.29726829,8.30039024 4.5995122,7.99814634 4.5995122,7.62546341 L4.5995122,3.3022439 C4.5995122,2.23629268 5.46682927,1.36936585 6.53239024,1.36936585 L33.4283902,1.36936585 C34.4939512,1.36936585 35.360878,2.23629268 35.360878,3.3022439 L35.360878,14.5419512 L24.966439,14.5419512 C26.5659512,13.6017561 27.896,12.2070244 28.7698537,10.4687805 C28.8658537,10.2782439 28.8658537,10.0529756 28.7698537,9.86243902 C27.0876098,6.51717073 23.7195122,4.43902439 19.9801951,4.43902439 C16.240878,4.43902439 12.8726829,6.51717073 11.1905366,9.86243902 C11.0949268,10.0529756 11.0949268,10.2782439 11.1905366,10.4687805 C11.5232195,11.1303415 11.9318049,11.7554146 12.4054634,12.3274146 C12.6433171,12.6147317 13.0689756,12.654439 13.3559024,12.4165854 C13.6433171,12.1788293 13.6833171,11.7534634 13.4454634,11.4661463 C13.1097561,11.0606829 12.8117073,10.6242927 12.5571707,10.1654634 C14.0552195,7.45697561 16.868878,5.78926829 19.9801951,5.78926829 C23.0915122,5.78926829 25.9050732,7.45736585 27.4036098,10.1658537 C25.9050732,12.8739512 23.0915122,14.5419512 19.9801951,14.5419512 C18.2606829,14.5419512 16.605561,14.0301463 15.192878,13.0621463 C14.8852683,12.8510244 14.4653659,12.929561 14.2541463,13.2370732 C14.0434146,13.5446829 14.121561,13.9649756 14.4294634,14.1757073 C14.6181463,14.304878 14.8109268,14.4265366 15.0072195,14.5419512 L4.59980488,14.5419512 L4.59980488,9.87580488 C4.59980488,9.50312195 4.29765854,9.20087805 3.92458537,9.20087805 C3.55180488,9.20087805 3.24965854,9.50312195 3.24965854,9.87580488 L3.24965854,14.6726829 C2.06712195,15.0411707 1.2057561,16.1463415 1.2057561,17.4489756 L1.2057561,20.4531707 L0.675317073,20.4531707 C0.302243902,20.4531707 0,20.7554146 0,21.1284878 L0,27.0397073 C0,27.4123902 0.302243902,27.7146341 0.675317073,27.7146341 L3.56702439,27.7146341 L3.56702439,31.3247805 C3.56702439,31.6974634 3.86926829,32 4.24195122,32 L8.52702439,32 C8.90019512,32 9.20234146,31.6974634 9.20234146,31.3247805 L9.20234146,27.7146341 L12.5102439,27.7146341 C12.8834146,27.7146341 13.185561,27.4123902 13.185561,27.0397073 C13.185561,26.6666341 12.8834146,26.3643902 12.5102439,26.3643902 L1.3502439,26.3643902 L1.3502439,21.8034146 L30.3292683,21.8034146 C30.7023415,21.8034146 31.0045854,21.5011707 31.0045854,21.1284878 C31.0045854,20.7554146 30.7023415,20.4531707 30.3292683,20.4531707 L2.556,20.4531707 L2.556,17.4489756 C2.556,16.5903415 3.25453659,15.8921951 4.11278049,15.8921951 L35.8482927,15.8921951 C36.7065366,15.8921951 37.4050732,16.5903415 37.4050732,17.4489756 L37.4050732,20.4531707 L32.5243902,20.4531707 C32.1517073,20.4531707 31.8494634,20.7554146 31.8494634,21.1284878 C31.8494634,21.5011707 32.1517073,21.8034146 32.5243902,21.8034146 L38.6109268,21.8034146 L38.6109268,26.3643902 L14.7057561,26.3643902 C14.3326829,26.3643902 14.030439,26.6666341 14.030439,27.0397073 C14.030439,27.4123902 14.3326829,27.7146341 14.7057561,27.7146341 L30.7587317,27.7146341 L30.7587317,31.3247805 C30.7587317,31.6974634 31.0609756,32 31.4336585,32 L35.719122,32 C36.0918049,32 36.3940488,31.6974634 36.3940488,31.3247805 L36.3940488,27.7146341 L39.2858537,27.7146341 C39.6589268,27.7146341 39.9611707,27.4123902 39.9611707,27.0397073 L39.9611707,21.1284878 C39.9611707,20.7554146 39.6589268,20.4531707 39.2858537,20.4531707 L39.2858537,20.4531707 Z" id="Fill-1" fill="#FFFFFF" mask="url(#mask-2)"></path></g><path d="M15.1930732,13.0621463 C14.885561,12.8510244 14.465561,12.929561 14.2543415,13.2370732 C14.0436098,13.5446829 14.1218537,13.9649756 14.4296585,14.1757073 C14.6183415,14.304878 14.811122,14.4265366 15.0075122,14.5419512 L19.9803902,14.5419512 C18.260878,14.5419512 16.6057561,14.0301463 15.1930732,13.0621463" id="Fill-4" fill="#FFFFFF"></path><path d="M28.7701463,10.4687805 C28.8661463,10.2782439 28.8661463,10.0529756 28.7701463,9.86243902 C27.0878049,6.51717073 23.7198049,4.43902439 19.9803902,4.43902439 C16.2411707,4.43902439 12.872878,6.51717073 11.1908293,9.86243902 C11.0952195,10.0529756 11.0952195,10.2782439 11.1908293,10.4687805 C11.5235122,11.1303415 11.9320976,11.7554146 12.4057561,12.3274146 C12.6436098,12.6147317 13.0691707,12.654439 13.3560976,12.4165854 C13.6436098,12.1788293 13.6835122,11.7534634 13.4456585,11.4661463 C13.1099512,11.0606829 12.8119024,10.6242927 12.5573659,10.1654634 C14.0554146,7.45697561 16.8691707,5.78926829 19.9803902,5.78926829 C23.0917073,5.78926829 25.9052683,7.45736585 27.4039024,10.1658537 C25.9052683,12.8739512 23.0917073,14.5419512 19.9803902,14.5419512 L24.9666341,14.5419512 C26.5662439,13.6017561 27.8962927,12.2070244 28.7701463,10.4687805" id="Fill-5" fill="#FFFFFF"></path></g></g></g></g></g></g></svg></div><div class="room-size__copy">Room size is ' + scene.data.roomSize + ' sqm</div></div>');
		} else {
			this.$titleSceneRoomSize.html('');
		}

		if (scene && scene.data && scene.data.video) {
			this.asset = scene.data.video.asset;
			this.$controls.addClass('is-visible');

			this.video.src = scene.data.video.src;

			if (this.isMobileOs()) {
				this.$playMobile.addClass('is-open');
			}

			this.waitForReadyState(this.video, this.video.HAVE_METADATA, 100, function () {
				this.waitForReadyState(this.video, this.video.HAVE_ENOUGH_DATA, 100, function () {
					this.asset.setVideo(this.video);
					this.video.play();
				}.bind(this));
			}.bind(this));
		}

		if (scene.position) {
			scene.scene.lookTo(scene.position, { transitionDuration: 0 });
		}
	}

	this.activeSceneId = scene.id;
	// SE IL MENU RISULTA ESSERE APERTO, LO CHIUDO
	if (this.$menuOverlay && this.$menuOverlay.hasClass('is-open')) {
		this.toggleMenu();
	}
};

MV360TourPublic.prototype.updateDurationIndicator = function () {
	var videoDuration = this.video ? this.formatTime(this.video.duration) : '-';
	this.$durationIndicatorElement.html(videoDuration);
}

MV360TourPublic.prototype.formatTime = function (d) {
	var h = Math.floor(d / 3600);
	var m = Math.floor(d % 3600 / 60);
	var s = Math.floor(d % 3600 % 60);
	return ((h > 0 ? h + ":" + (m < 10 ? "0" : "") : "") + m + ":" + (s < 10 ? "0" : "") + s);
};

MV360TourPublic.prototype.mute = function (e) {
	e.preventDefault();
	if (!this.video) {
		return;
	}
	var newVolume = 0;
	if (this.video.volume > 0) {
		this.$muteElement.addClass('is-mute');
	} else {
		this.$muteElement.removeClass('is-mute');
		newVolume = 1;
	}
	this.video.volume = newVolume;
};

MV360TourPublic.prototype.playPause = function (e) {
	e.preventDefault();
	if (!this.video) {
		return;
	}
	if (this.video.paused) {
		var playPromise = this.video.play();
		if (playPromise !== 'undefined') {
			playPromise.then(function () {
				this.$playMobile.removeClass('is-open');
			}.bind(this)).catch(function (error) {
				this.$playMobile.addClass('is-open');

				// Automatic playback failed.
				// Show a UI element to let the user manually start playback.
			}.bind(this));
		}
		this.$playPauseElement.addClass('is-pause');
	} else {
		this.video.pause();
		this.$playPauseElement.removeClass('is-pause');
	}
};

MV360TourPublic.prototype.updateCurrentTimeIndicator = function (e) {
	var html = this.video ? this.formatTime(this.video.currentTime) : '-';
	this.$currentTimeIndicatorElement.html(html);
};

MV360TourPublic.prototype.updateProgressBar = function (e) {
	if (!this.video) {
		return;
	}
	var progress = this.video.currentTime / this.video.duration;
	this.$progressFillElement.width((progress * 100) + '%');
};

MV360TourPublic.prototype.progressBackground = function (e) {
	if (!this.video) {
		return;
	}
	this.video.currentTime = this.percentFromClick(e) * this.video.duration;
};

MV360TourPublic.prototype.percentFromClick = function (e) {
	var rect = this.$progressBackgroundElement.get(0).getBoundingClientRect();
	var click = e.clientX - rect.left;
	var total = rect.right - rect.left;
	return click / total;
};

MV360TourPublic.prototype.waitForReadyState = function (element, readyState, interval, done) {
	var timer = setInterval(function () {
		if (element.readyState >= readyState) {
			clearInterval(timer);
			done(null, true);
		}
	}, interval);
};


// Custom control method to alter the view according to the device orientation.
function MV360TourPublicDeviceOrientationControlMethod() {
	this._dynamics = {
		yaw: new Marzipano.Dynamics(),
		pitch: new Marzipano.Dynamics()
	};

	this._deviceOrientationHandler = this._handleData.bind(this);

	if (window.DeviceOrientationEvent) {
		window.addEventListener('deviceorientation', this._deviceOrientationHandler);
	}

	this._previous = {};
	this._current = {};
	this._tmp = {};

	this._getPitchCallbacks = [];
}

Marzipano.dependencies.eventEmitter(MV360TourPublicDeviceOrientationControlMethod);

MV360TourPublicDeviceOrientationControlMethod.prototype.destroy = function () {
	this._dynamics = null;
	if (window.DeviceOrientationEvent) {
		window.removeEventListener('deviceorientation', this._deviceOrientationHandler);
	}
	this._deviceOrientationHandler = null;
	this._previous = null;
	this._current = null;
	this._tmp = null;
	this._getPitchCallbacks = null;
};

MV360TourPublicDeviceOrientationControlMethod.prototype.getPitch = function (cb) {
	this._getPitchCallbacks.push(cb);
};


MV360TourPublicDeviceOrientationControlMethod.prototype._handleData = function (data) {
	var previous = this._previous,
		current = this._current,
		tmp = this._tmp;

	tmp.yaw = Marzipano.util.degToRad(data.alpha);
	tmp.pitch = Marzipano.util.degToRad(data.beta);
	tmp.roll = Marzipano.util.degToRad(data.gamma);

	rotateEuler(tmp, current);

	// Report current pitch value.
	this._getPitchCallbacks.forEach(function (callback) {
		callback(null, current.pitch);
	});
	this._getPitchCallbacks.length = 0;

	// Emit control offsets.
	if (previous.yaw != null && previous.pitch != null && previous.roll != null) {
		this._dynamics.yaw.offset = -(current.yaw - previous.yaw);
		this._dynamics.pitch.offset = (current.pitch - previous.pitch);

		this.emit('parameterDynamics', 'yaw', this._dynamics.yaw);
		this.emit('parameterDynamics', 'pitch', this._dynamics.pitch);
	}

	previous.yaw = current.yaw;
	previous.pitch = current.pitch;
	previous.roll = current.roll;
};

// Taken from krpano's gyro plugin by Aldo Hoeben:
// https://github.com/fieldOfView/krpano_fovplugins/tree/master/gyro/
// For the math, see references:
// http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToMatrix/index.htm
// http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToEuler/index.htm
function rotateEuler(euler, result) {
	var heading, bank, attitude,
		ch = Math.cos(euler.yaw),
		sh = Math.sin(euler.yaw),
		ca = Math.cos(euler.pitch),
		sa = Math.sin(euler.pitch),
		cb = Math.cos(euler.roll),
		sb = Math.sin(euler.roll),

		matrix = [
			sh * sb - ch * sa * cb, -ch * ca, ch * sa * sb + sh * cb,
			ca * cb, -sa, -ca * sb,
			sh * sa * cb + ch * sb, sh * ca, -sh * sa * sb + ch * cb
		]; // Includes 90-degree rotation around z axis

  /* [m00 m01 m02] 0 1 2
   * [m10 m11 m12] 3 4 5
   * [m20 m21 m22] 6 7 8 */

	if (matrix[3] > 0.9999) {
		// Deal with singularity at north pole
		heading = Math.atan2(matrix[2], matrix[8]);
		attitude = Math.PI / 2;
		bank = 0;
	}
	else if (matrix[3] < -0.9999) {
		// Deal with singularity at south pole
		heading = Math.atan2(matrix[2], matrix[8]);
		attitude = -Math.PI / 2;
		bank = 0;
	}
	else {
		heading = Math.atan2(-matrix[6], matrix[0]);
		bank = Math.atan2(-matrix[5], matrix[4]);
		attitude = Math.asin(matrix[3]);
	}

	result.yaw = heading;
	result.pitch = attitude;
	result.roll = bank;
}
