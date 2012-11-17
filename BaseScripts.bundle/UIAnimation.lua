require "Object"

UIAnimation = {};
UIAnimation.__index = UIAnimation;
setmetatable(UIAnimation, Object);

-- constant
UIViewAnimationOptionLayoutSubviews            = 1;
UIViewAnimationOptionAllowUserInteraction      = 2;
UIViewAnimationOptionBeginFromCurrentState     = 4;
UIViewAnimationOptionRepeat                    = 8;
UIViewAnimationOptionAutoreverse               = 16;
UIViewAnimationOptionOverrideInheritedDuration = 32;
UIViewAnimationOptionOverrideInheritedCurve    = 64;
UIViewAnimationOptionAllowAnimatedContent      = 128;
UIViewAnimationOptionShowHideTransitionViews   = 256;

UIViewAnimationOptionCurveEaseInOut            = 0;
UIViewAnimationOptionCurveEaseIn               = 65536;
UIViewAnimationOptionCurveEaseOut              = 131072;
UIViewAnimationOptionCurveLinear               = 196608;

UIViewAnimationOptionTransitionNone            = 0;
UIViewAnimationOptionTransitionFlipFromLeft    = 1048576;
UIViewAnimationOptionTransitionFlipFromRight   = 2097152;
UIViewAnimationOptionTransitionCurlUp          = 3145728;
UIViewAnimationOptionTransitionCurlDown        = 4194304;
UIViewAnimationOptionTransitionCrossDissolve   = 5242880;
UIViewAnimationOptionTransitionFlipFromTop     = 6291456;
UIViewAnimationOptionTransitionFlipFromBottom  = 7340032;

-- constructor
function UIAnimation:create()
    local animId = tostring(math::random());
    local anim = Object:new(animId);
    setmetatable(anim, self);
    eventProxy_animation[animId] = anim;
    
    return anim;
end

function UIAnimation:dealloc()
    eventProxy_animation[self:id()] = nil;
end

function UIAnimation:start(duration, delay, options)
    if duration == nil then
        duration = 0.25;
    end
    if delay == nil then
        delay = 0;
    end
    if options == nil then
        options = 0;
    end
    ui::animate(self:id(), duration, delay, options, "epf_animation", "epf_animation_complete");
end

-- instance methods
function UIAnimation:animation()
    
end

function UIAnimation:complete()
    
end

-- event proxy
eventProxy_animation = {};

function epf_animation(animId)
    eventProxy_animation[animId]:animation();
end

function epf_animation_complete(animId)
    eventProxy_animation[animId]:complete();
end