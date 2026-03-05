if getgenv().Optimization then return end
getgenv().Optimization = true

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer

if setfpscap then setfpscap(9999) end

pcall(function()
    settings().Network.IncomingReplicationLag = -1
    settings().Network.PhysicsSendRate = 60
    settings().Network.DataSendRate = 60
end)

local focusPart = Instance.new("Part")
focusPart.Name = "ClientFocus"
focusPart.Transparency = 1
focusPart.Anchored = true
focusPart.CanCollide = false
focusPart.CanTouch = false
focusPart.CastShadow = false
focusPart.Parent = workspace

RunService.Heartbeat:Connect(function()
    local cam = workspace.CurrentCamera
    if cam then
        focusPart.CFrame = cam.CFrame
        LocalPlayer.ReplicationFocus = focusPart
    end
end)

local OptimizationInterval = 60
local lastOptimization = 0

local function PutPhysicsToSleep()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Anchored then
                v.Velocity = Vector3.new(0, 0, 0)
                v.RotVelocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

local function CleanAssets()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Size.Magnitude < 1 then
            v.CastShadow = false
        end
    end
end

local function DisableClouds()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Clouds") then
            v.Enabled = false
        end
    end
end

local function OptimizeAtmosphere()
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        atmosphere.Density = 0
        atmosphere.Glare = 0
        atmosphere.Haze = 0
    end
end

local function OptimizeTerrain()
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    if Terrain then
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end
end

local function SafeMemoryReclaim()
    pcall(function()
        for i = 1, 5 do
            local t = Instance.new("Folder")
            t.Parent = game:GetService("ReplicatedStorage")
            Debris:AddItem(t, 0.1)
        end
    end)
end

getgenv().RunOptimizer = function()
    PutPhysicsToSleep()
    CleanAssets()
    SafeMemoryReclaim()
end

getgenv().StopOptimizer = function()
    getgenv().Optimization = false
end

DisableClouds()
OptimizeAtmosphere()
OptimizeTerrain()

RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - lastOptimization > OptimizationInterval then
        lastOptimization = now
        task.spawn(function()
            PutPhysicsToSleep()
            CleanAssets()
            SafeMemoryReclaim()
        end)
    end
end)

Players.PlayerAdded:Connect(function()
    task.spawn(function()
        PutPhysicsToSleep()
        CleanAssets()
    end)
end)

workspace.DescendantAdded:Connect(function(v)
    if v:IsA("BasePart") then
        if v.Size.Magnitude < 1 then
            v.CastShadow = false
        end
    end
    if v:IsA("Clouds") then
        v.Enabled = false
    end
end)

local FastFlags = {
    ["FFlagHandleAltEnterFullscreenManually"] = "False",
    ["FLogNetwork"] = "7",
    ["FIntRenderShadowIntensity"] = "0",
    ["DFIntCanHideGuiGroupId"] = "32380007",
    ["FIntFullscreenTitleBarTriggerDelayMillis"] = "3600000",
    ["FFlagDisablePostFx"] = "True",
    ["FIntTerrainArraySliceSize"] = "0",
    ["DFIntTaskSchedulerTargetFps"] = "9999",
    ["FIntDebugForceMSAASamples"] = "1",
    ["DFFlagDebugRenderForceTechnologyVoxel"] = "True",
    ["DFFlagDisableDPIScale"] = "True",
    ["DFIntTextureQualityOverride"] = "3",
    ["DFFlagTextureQualityOverrideEnabled"] = "True",
    ["FFlagDebugGraphicsPreferD3D11"] = "True",
    ["DFIntServerTickRate"] = "60",
    ["FFlagDebugForceFutureIsBrightPhase3"] = "True",
    ["FFlagOptimizeServerTickRate"] = "True",
    ["FFlagDebugGraphicsPreferD3D11FL10"] = "True",
    ["DFIntPlayerNetworkUpdateRate"] = "60",
    ["DFIntOptimizePingThreshold"] = "50",
    ["DFIntRakNetResendRttMultiple"] = "1",
    ["DFIntPlayerNetworkUpdateQueueSize"] = "20",
    ["DFIntNetworkPrediction"] = "120",
    ["FFlagOptimizeNetworkRouting"] = "True",
    ["FIntRakNetResendBufferArrayLength"] = "128",
    ["DFIntConnectionMTUSize"] = "900",
    ["FFlagOptimizeNetwork"] = "True",
    ["DFIntNetworkLatencyTolerance"] = "1",
    ["DFIntMaxFrameBufferSize"] = "4",
    ["DFIntRaknetBandwidthPingSendEveryXSeconds"] = "1",
    ["FFlagOptimizeNetworkTransport"] = "True",
    ["DFIntServerPhysicsUpdateRate"] = "60",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["DFIntRuntimeConcurrency"] = "3555",
    ["DFFlagAudioEnableVolumetricPanningForMeshes"] = "True",
    ["DFFlagAudioEnableVolumetricPanningForPolys"] = "True",
    ["DFFlagAudioUseVolumetricPanning"] = "True",
    ["DFFlagDebugLargeReplicatorDisableCompression"] = "True",
    ["DFFlagDebugLargeReplicatorDisableDelta"] = "True",
    ["DFFlagDebugLargeReplicatorForceFullSend"] = "True",
    ["DFFlagDebugOverrideDPIScale"] = "False",
    ["DFFlagDebugPauseVoxelizer"] = "True",
    ["DFFlagDebugPerfMode"] = "True",
    ["DFFlagDebugSkipMeshVoxelizer"] = "True",
    ["DFFlagEnableMeshPreloading2"] = "True",
    ["DFFlagEnablePreloadAvatarAssets"] = "True",
    ["DFFlagEnableSoundPreloading"] = "True",
    ["DFFlagEnableTexturePreloading"] = "True",
    ["DFFlagNextGenRepRollbackOverbudgetPackets"] = "True",
    ["DFFlagOptimizeNoCollisionPrimitiveInMidphaseCrash"] = "True",
    ["DFFlagPerformanceControlEnableMemoryProbing3"] = "True",
    ["DFFlagSampleAndRefreshRakPing"] = "True",
    ["DFFlagSimOptimizeSetSize"] = "True",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment"] = "True",
    ["DFFlagTeleportClientAssetPreloadingDoingExperiment2"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabled9"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP"] = "True",
    ["DFFlagTeleportClientAssetPreloadingEnabledIXP2"] = "True",
    ["DFFlagTeleportPreloadingMetrics5"] = "True",
    ["DFIntAnimationLodFacsDistanceMax"] = "0",
    ["DFIntAnimationLodFacsDistanceMin"] = "0",
    ["DFIntAnimationLodFacsVisibilityDenominator"] = "0",
    ["DFIntAssetPreloading"] = "2147483647",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0",
    ["DFIntContentProviderPreloadHangTelemetryHundredthsPercentage"] = "0",
    ["DFIntCullFactorPixelThresholdShadowMapHighQuality"] = "2147483647",
    ["DFIntCullFactorPixelThresholdShadowMapLowQuality"] = "2147483647",
    ["DFIntDataSenderRate"] = "38760",
    ["DFIntDebugFRMQualityLevelOverride"] = "0",
    ["DFIntHACDPointSampleDistApartTenths"] = "2147483647",
    ["DFIntMemoryUtilityCurveBaseHundrethsPercent"] = "10000",
    ["DFIntMemoryUtilityCurveNumSegments"] = "100",
    ["DFIntMemoryUtilityCurveTotalMemoryReserve"] = "0",
    ["DFIntNumAssetsMaxToPreload"] = "2147483647",
    ["DFIntPerformanceControlTextureQualityBestUtility"] = "-1",
    ["DFIntPreloadAvatarAssets"] = "2147483647",
    ["DFIntS2PhysicsSenderRate"] = "38760",
    ["DFIntTeleportClientAssetPreloadingHundredthsPercentage"] = "100000",
    ["DFIntTeleportClientAssetPreloadingHundredthsPercentage2"] = "100000",
    ["DFIntTrackCountryRegionAPIHundredthsPercent"] = "10000",
    ["DFIntVoiceChatVolumeThousandths"] = "5000",
    ["FFlagAssetPreloadingIXP"] = "True",
    ["FFlagBetaBadgeLearnMoreLinkFormview"] = "False",
    ["FFlagBetterTrackpadScrolling"] = "True",
    ["FFlagContentProviderPreloadHangTelemetry"] = "False",
    ["FFlagControlBetaBadgeWithGuac"] = "False",
    ["FFlagDebugCheckRenderThreading"] = "True",
    ["FFlagDebugDeterministicParticles"] = "False",
    ["FFlagDebugDisableTelemetryEphemeralCounter"] = "True",
    ["FFlagDebugDisableTelemetryEphemeralStat"] = "True",
    ["FFlagDebugDisableTelemetryEventIngest"] = "True",
    ["FFlagDebugDisableTelemetryPoint"] = "True",
    ["FFlagDebugDisableTelemetryV2Counter"] = "True",
    ["FFlagDebugDisableTelemetryV2Event"] = "True",
    ["FFlagDebugDisableTelemetryV2Stat"] = "True",
    ["FFlagDebugEnableDirectAudioOcclusion2"] = "True",
    ["FFlagDebugForceFSMCPULightCulling"] = "True",
    ["FFlagDebugForceGenerateHSR"] = "True",
    ["FFlagDebugLargeReplicatorEnabled"] = "True",
    ["FFlagDebugLargeReplicatorRead"] = "True",
    ["FFlagDebugLargeReplicatorWrite"] = "True",
    ["FFlagDebugSSAOForce"] = "False",
    ["FFlagEnableAudioPannerFiltering"] = "True",
    ["FFlagEnableInGameMenuDurationLogger"] = "False",
    ["FFlagEnablePartyVoiceOnlyForEligibleUsers"] = "False",
    ["FFlagEnablePartyVoiceOnlyForUnfilteredThreads"] = "False",
    ["FFlagEnablePreferredTextSizeGuiService"] = "True",
    ["FFlagEnablePreferredTextSizeScale"] = "True",
    ["FFlagEnablePreferredTextSizeSettingInMenus2"] = "True",
    ["FFlagEnablePreferredTextSizeStyleFixesInAppShell3"] = "True",
    ["FFlagEnablePreferredTextSizeStyleFixesInAvatarExp"] = "True",
    ["FFlagFRMRefactor"] = "False",
    ["FFlagFastGPULightCulling3"] = "True",
    ["FFlagFixIGMTabTransitions"] = "True",
    ["FFlagFixOutdatedParticles2"] = "False",
    ["FFlagFixOutdatedTimeScaleParticles"] = "False",
    ["FFlagFixParticleAttachmentCulling"] = "False",
    ["FFlagFixParticleEmissionBias2"] = "False",
    ["FFlagFixSensitivityTextPrecision"] = "False",
    ["FFlagHighlightOutlinesOnMobile"] = "True",
    ["FFlagImproveShiftLockTransition"] = "True",
    ["FFlagLoginPageOptimizedPngs"] = "True",
    ["FFlagLuaMenuPerfImprovements"] = "True",
    ["FFlagLuauCodegen"] = "True",
    ["FFlagMessageBusCallOptimization"] = "True",
    ["FFlagNewLightAttenuation"] = "True",
    ["FFlagNewOptimizeNoCollisionPrimitiveInMidphase660"] = "True",
    ["FFlagNextGenReplicatorEnabledRead2"] = "True",
    ["FFlagNextGenReplicatorEnabledWrite2"] = "True",
    ["FFlagPreloadAllFonts"] = "True",
    ["FFlagPreloadTextureItemsOption4"] = "True",
    ["FFlagQuaternionPoseCorrection"] = "True",
    ["FFlagRenderCBRefactor2"] = "True",
    ["FFlagRenderDynamicResolutionScale11"] = "True",
    ["FFlagRenderLegacyShadowsQualityRefactor"] = "True",
    ["FFlagRenderNoLowFrmBloom"] = "False",
    ["FFlagRenderSkipReadingShaderData"] = "False",
    ["FFlagShaderLightingRefactor"] = "False",
    ["FFlagShoeSkipRenderMesh"] = "False",
    ["FFlagSimEnableDCD16"] = "True",
    ["FFlagUserBetterInertialScrolling"] = "True",
    ["FFlagUserCameraControlLastInputTypeUpdate"] = "False",
    ["FFlagUserShowGuiHideToggles"] = "True",
    ["FFlagUserSoundsUseRelativeVelocity2"] = "True",
    ["FFlagVideoServiceAddHardwareCodecMetrics"] = "True",
    ["FFlagVoiceBetaBadge"] = "False",
    ["FIntCAP1209DataSharingTOSVersion"] = "0",
    ["FIntCAP1544DataSharingUserRolloutPercentage"] = "0",
    ["FIntCameraMaxZoomDistance"] = "2147483647",
    ["FIntDebugFRMOptionalMSAALevelOverride"] = "0",
    ["FIntDirectionalAttenuationMaxPoints"] = "0",
    ["FIntEnableVisBugChecksHundredthPercent27"] = "100",
    ["FIntFRMMaxGrassDistance"] = "0",
    ["FIntFRMMinGrassDistance"] = "0",
    ["FIntGrassMovementReducedMotionFactor"] = "0",
    ["FIntPreferredTextSizeSettingBetaFeatureRolloutPercent"] = "100",
    ["FIntRenderGrassDetailStrands"] = "0",
    ["FIntRenderLocalLightFadeInMs"] = "0",
    ["FIntRenderLocalLightUpdatesMax"] = "1",
    ["FIntRenderLocalLightUpdatesMin"] = "1",
    ["FIntRenderMaxShadowAtlasUsageBeforeDownscale"] = "0",
    ["FIntRenderMeshOptimizeVertexBuffer"] = "1",
    ["FIntRenderShadowmapBias"] = "0",
    ["FIntSSAOMipLevels"] = "0",
    ["FIntUITextureMaxUpdateDepth"] = "1",
    ["FIntUnifiedLightingBlendZone"] = "0",
    ["FIntVertexSmoothingGroupTolerance"] = "0",
    ["FStringGetPlayerImageDefaultTimeout"] = "1",
    ["FStringTerrainMaterialTable2022"] = "",
    ["FStringTerrainMaterialTablePre2022"] = "",
    ["FStringVoiceBetaBadgeLearnMoreLink"] = "null",
    ["FFlagRenderCullExtraFarPlanets"] = "True",
    ["FIntRenderDepthOfFieldSamples"] = "0",
    ["FFlagRenderFixImposterColor"] = "True",
    ["FIntRenderRefractionQuality"] = "0",
    ["FFlagRenderD3D11SetConstantBufferOnce"] = "True",
    ["FIntRenderResolutionReducedThreshold"] = "50",
    ["FFlagPhysicsCullMovingParts"] = "True",
    ["FFlagPhysicsSolverPredictiveActive"] = "True",
    ["FIntPhysicsGridLOD"] = "0",
    ["FFlagPhysicsGJKFinalImprovement"] = "True",
    ["FFlagPhysicsInertiaTensorFix"] = "True",
    ["FFlagPhysicsVariableTimestep"] = "True",
    ["FIntTextureCompositorCacheSize"] = "32",
    ["FFlagRenderTextureManagerCollectGarbage"] = "True",
    ["FIntTextureManagerMaxVRAMWeight"] = "128",
    ["DFFlagTextureQualityForceReduced"] = "True",
    ["FFlagRenderEnableTextureStreaming"] = "True",
    ["FIntRenderTextureStreamingRadius"] = "64",
    ["FFlagHumanoidOnlyUpdateVisible"] = "True",
    ["FFlagHumanoidParallelMovement"] = "True",
    ["FIntHumanoidLODDistance"] = "50",
    ["FFlagHumanoidSimpleStep"] = "True",
    ["FFlagHumanoidUpdateOptimized"] = "True",
    ["FFlagRenderForceLowDetailReflections"] = "True",
    ["FIntRenderShadowCascadeCount"] = "1",
    ["FFlagRenderDisableShadowMask"] = "True",
    ["FIntRenderToneMappingCurve"] = "0",
    ["FFlagRenderNoDistortion"] = "True",
    ["FIntRenderGpuHsrMargin"] = "0",
    ["FFlagRenderUseGpuFullHsr"] = "True"
}

for flag, value in pairs(FastFlags) do
    pcall(function()
        setfflag(flag, value)
    end)
end

local HttpService = game:GetService("HttpService")

local function GetEmptyResponse()
    return {
        StatusCode = 200,
        StatusMessage = "OK",
        Headers = {["content-type"] = "application/json"},
        Body = "{}"
    }
end

local function Protect(name)
    local func = getgenv()[name]
    if func then
        getgenv()[name] = newcclosure(function(options)
            local url = string.lower(options.Url or options.url or "")
            if url:find("discord.com") then
                return GetEmptyResponse()
            end
            return func(options)
        end)
    end
end

local old_nc
old_nc = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if self == HttpService and (method == "PostAsync" or method == "RequestAsync") then
        local url = string.lower((type(args[1]) == "string" and args[1]) or (type(args[1]) == "table" and args[1].Url) or "")
        
        if url:find("discord.com") then
            return nil
        end
    end
    
    return old_nc(self, ...)
end)

local targets = {"request", "syn.request", "http_request"}
for _, name in ipairs(targets) do
    pcall(function() Protect(name) end)
end
