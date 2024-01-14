// Use kanzi.hpp only when you are learning to develop Kanzi applications.
// To improve compilation time in production projects, include only the header files of the Kanzi functionality you are using.
#include <iostream>
#include <kanzi/kanzi.hpp>
#include <kanzi/core/log/log.hpp>

// [CodeBehind libs inclusion]. Do not remove this identifier.

#if defined(TRUBAN_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
#include <TRuban_code_behind_module.hpp>
#endif

using namespace kanzi;

class TRuban : public ExampleApplication
{
public:

    void onConfigure(ApplicationProperties& configuration) override
    {
        configuration.binaryName = "truban.kzb.cfg";
    }

    void onProjectLoaded() override
    {
        // Project file has been loaded from .kzb file.

        // Add initialization code here.
        m_screenNode = getScreen();
        m_rootPagePtr = m_screenNode->lookupNode<Node2D>("RootPage");
        m_viewportPtr = m_rootPagePtr->lookupNode<Node2D>("Viewport 2D");
        m_wheelImgNodes[0] = m_viewportPtr->lookupNode<Node2D>("TireFR");
        m_wheelImgNodes[1] = m_viewportPtr->lookupNode<Node2D>("TireFL");
        m_wheelImgNodes[2] = m_viewportPtr->lookupNode<Node2D>("TireRL");
        m_wheelImgNodes[3] = m_viewportPtr->lookupNode<Node2D>("TireRR");

        for (int i = 0; i < 4; ++i) {
            m_wheelSlipData[i] = 0.0;
            m_wheelAnimationFrameFreq[i] = 1.0;
            m_wheelAnimationFrameCount[i] = 0.0;
            m_wheelAnimationFrameMaxOpacity[i] = 0.0;
            m_wheelAnimationFrameIncreaseCoeffs[i] = 1.0;
        }
    }

    void onUpdate(chrono::nanoseconds deltaTime) override {

        for (int i = 0; i < 4; ++i) {
   
            m_wheelAnimationFrameCount[i] += m_wheelAnimationFrameIncreaseCoeffs[i];
            m_wheelSlipData[i] = (i + 1) * 0.23;

            if (m_wheelSlipData[i] > TRACTION_BAD_LIMIT && m_wheelSlipData[i] < TRACTION_CRITICAL_LIMIT) {
                m_wheelAnimationFrameCount[i] = 60 * static_cast<float>(m_wheelAnimationFrameCount[i]) / m_wheelAnimationFrameFreq[i];
                m_wheelAnimationFrameFreq[i] = 60;
                m_wheelAnimationFrameMaxOpacity[i] = 1.0;
            }
            else if (m_wheelSlipData[i] >= TRACTION_CRITICAL_LIMIT) {
                m_wheelAnimationFrameCount[i] = 16 * static_cast<float>(m_wheelAnimationFrameCount[i]) / m_wheelAnimationFrameFreq[i];
                m_wheelAnimationFrameFreq[i] = 16;
                m_wheelAnimationFrameMaxOpacity[i] = 1.0;
            }
            else {
                m_wheelAnimationFrameCount[i] = 300 * static_cast<float>(m_wheelAnimationFrameCount[i]) / m_wheelAnimationFrameFreq[i];
                m_wheelAnimationFrameFreq[i] = 300;
                m_wheelAnimationFrameMaxOpacity[i] = 0.2;
            }

            m_wheelImgNodes[i]->setProperty(DynamicPropertyType<float>("kzSlipPercent"), std::max(std::min(m_wheelAnimationFrameMaxOpacity[i] *
                (static_cast<float>(m_wheelAnimationFrameCount[i]) / static_cast<float>(m_wheelAnimationFrameFreq[i]) + 0.2f), m_wheelAnimationFrameMaxOpacity[i]), 0.2f));

            if (m_wheelAnimationFrameCount[i] >= m_wheelAnimationFrameFreq[i] / 2) {
                m_wheelAnimationFrameIncreaseCoeffs[i] = -1;
                m_wheelAnimationFrameCount[i] = m_wheelAnimationFrameFreq[i] / 2;
            }

            if (m_wheelAnimationFrameCount[i] <= 0) {
                m_wheelAnimationFrameIncreaseCoeffs[i] = 1;
                m_wheelAnimationFrameCount[i] = 0;
            }
        }
        m_viewportPtr->setProperty(DynamicPropertyType<float>("TRuban.SlipWheelFL"), m_wheelSlipData[1]);
        m_viewportPtr->setProperty(DynamicPropertyType<float>("TRuban.SlipWheelFR"), m_wheelSlipData[0]);
        m_viewportPtr->setProperty(DynamicPropertyType<float>("TRuban.SlipWheelRL"), m_wheelSlipData[2]);
        m_viewportPtr->setProperty(DynamicPropertyType<float>("TRuban.SlipWheelRR"), m_wheelSlipData[3]);
    }

    void registerMetadataOverride(ObjectFactory& factory) override
    {
        ExampleApplication::registerMetadataOverride(factory);

#if defined(TRUBAN_CODE_BEHIND_API) && !defined(ANDROID) && !defined(KANZI_CORE_API_IMPORT)
        TRubanCodeBehindModule::registerModule(getDomain());
#endif

        // [CodeBehind module inclusion]. Do not remove this identifier.
    }
private:
    ScreenSharedPtr m_screenNode;
    Node2DSharedPtr m_rootPagePtr;
    Node2DSharedPtr m_viewportPtr;

    // 1 - 4 like coordinate system
    std::array<Node2DSharedPtr, 4> m_wheelImgNodes;

    std::array<float, 4> m_wheelSlipData;
    std::array<int, 4> m_wheelAnimationFrameFreq;
    std::array<int, 4> m_wheelAnimationFrameCount;
    std::array<float, 4> m_wheelAnimationFrameMaxOpacity;
    std::array<float, 4> m_wheelAnimationFrameIncreaseCoeffs;

    static constexpr float TRACTION_BAD_LIMIT = 0.3;
    static constexpr float TRACTION_CRITICAL_LIMIT = 0.9;
};

Application* createApplication()
{
    return new TRuban;
}
