class CapturePipeline < Formula
  desc "Screen + audio capture → AI analysis via OpenAI (vision, whisper, summary)"
  homepage "https://github.com/USER/capture-pipeline"
  url "https://github.com/USER/capture-pipeline/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "REPLACE_WITH_SHA256"  # run: shasum -a 256 v0.2.0.tar.gz
  license "MIT"

  depends_on "uv"
  depends_on cask: "blackhole-2ch"

  def install
    # Install via uv to keep deps isolated
    system "uv", "tool", "install", "--python", "python3", "."
  end

  def caveats
    <<~EOS
      Audio setup required:

      1. Reboot your Mac (BlackHole driver needs restart).
      2. Open Audio MIDI Setup.app (in /System/Applications/Utilities).
      3. Create Multi-Output Device:
         + → Create Multi-Output Device → check BlackHole 2ch + your speakers.
      4. Create Aggregate Device:
         + → Create Aggregate Device → check BlackHole 2ch + your microphone.
      5. System Settings → Sound → Output → select Multi-Output Device.
      6. Set your OpenAI key:
         echo 'OPENAI_API_KEY=sk-...' > ~/.capture-pipeline.env

      Launch:
        cd to your working directory and run:
          capture-pipeline

      To uninstall:
        brew uninstall capture-pipeline
        brew untap USER/capture
        brew uninstall --cask blackhole-2ch  # optional

      Note: ~/.capture-pipeline.env and output/ files are left intact.
    EOS
  end

  test do
    # Basic import check
    system "uv", "run", "python", "-c", <<~PYTHON
      from capture import ScreenCapture, AudioCapture
      from processor import VisionProcessor, AudioProcessor, Translator, Summarizer
      print("OK")
    PYTHON
  end
end
