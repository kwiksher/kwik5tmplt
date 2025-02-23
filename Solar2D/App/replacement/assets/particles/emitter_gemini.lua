--
-- For more information on emitter properties, see the EmitterObject documentation at:
-- https://docs.coronalabs.com/api/type/EmitterObject/index.html
--

local emitterParams = {
    angle = -90,
    angleVariance = 0,
    blendFuncDestination  = 1,  -- Additive Blending for Fire Effect!
    blendFuncSource = 770,
    duration  = -1,
    emitterType = 0,
    finishColorAlpha  = 0,
    finishColorBlue = 0.0,
    finishColorGreen  = 0.2, -- Less green as well
    finishColorGreen  = 0.2, -- Less green as well
    finishColorRed  = 0.8,   -- Slightly less red, fading out
    finishColorVarianceAlpha  = 0,
    finishColorVarianceBlue = 0,
    finishColorVarianceGreen  = 0,
    finishColorVarianceRed  = 0,
    finishParticleSize  = 20,
    finishParticleSizeVariance  = 40,
    gravityx  = 0,
    gravityy  = 0,
    maxParticles  = 100,
    maxRadius = 0,
    maxRadiusVariance = 72,
    minRadiusVariance = 0,
    particleLifespan  = 0.8,
    particleLifespanVariance  = 0,
    radialAcceleration  = 0,
    rotatePerSecond = 0,
    rotatePerSecondVariance = 152.9,
    rotationEnd = 0,
    rotationEndVariance = 0,
    rotationStart = 0,
    rotationStartVariance = 0,
    sourcePositionVariancex = 0,
    sourcePositionVariancey = 0,
    speed = 320,
    speedVariance = 0,
    startColorAlpha = 0.9,   -- Start with higher alpha for more solidity
    startColorBlue  = 0.0,   -- No Blue (warm colors)
    startColorGreen = 0.6,  -- Some Green (towards yellow/orange)
    startColorRed = 1.0,    -- Full Red
    startColorVarianceAlpha = 0,
    startColorVarianceBlue  = 0,
    startColorVarianceGreen = 0,
    startColorVarianceRed = 0,
    startParticleSize = 100,
    startParticleSizeVariance = 50,
    tangentialAcceleration  = 0,
    tangentialAccelVariance = 0,
    textureFileName = "particle.png", -- Or consider a softer texture
  minRadius = 0,
}

return emitterParams
