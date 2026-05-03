class CapturePipeline < Formula
  desc "Screen + audio capture → AI analysis via OpenAI (vision, whisper, summary)"
  homepage "https://github.com/dsk53910/capture-pipeline"
  url "https://github.com/dsk53910/capture-pipeline/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7c1eb11a85441d9bb378d877c5b24bf0121f3592e02184ad8d841c7685ed77bd"
  license "MIT"

  depends_on "uv"

  def install
    # Install via uv to keep deps isolated
    system "uv", "tool", "install", "--python", "python3", "."
  end

  def caveats
    <<~EOS
      Audio setup required:

      1. Install audio loopback:
         brew install --cask blackhole-2ch
      2. Reboot your Mac (BlackHole driver needs restart).
      3. Open Audio MIDI Setup.app (in /System/Applications/Utilities).
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
        brew untap dsk53910/capture-pipeline
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
