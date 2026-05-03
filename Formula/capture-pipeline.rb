class CapturePipeline < Formula
  desc "Screen + audio capture → AI analysis via OpenAI (vision, whisper, summary)"
  homepage "https://github.com/dsk53910/capture-pipeline"
  url "https://github.com/dsk53910/capture-pipeline/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7c1eb11a85441d9bb378d877c5b24bf0121f3592e02184ad8d841c7685ed77bd"
  license "MIT"

  depends_on "uv"

  def install
    # Copy project files and install deps with uv
    libexec.install Dir["*"]
    system "uv", "sync", chdir: libexec

    # Wrapper scripts
    (bin/"capture-pipeline").write <<~SH
      #!/bin/bash
      cd "#{libexec}" && exec uv run python pipeline_tui.py "$@"
    SH
    (bin/"capture-server").write <<~SH
      #!/bin/bash
      cd "#{libexec}" && exec uv run python pipeline_server.py "$@"
    SH
    (bin/"capture-headless").write <<~SH
      #!/bin/bash
      cd "#{libexec}" && exec uv run python main.py "$@"
    SH
    (bin/"capture-transcribe").write <<~SH
      #!/bin/bash
      cd "#{libexec}" && exec uv run python transcribe_mov.py "$@"
    SH
    chmod 0755, Dir[bin/"*"]
  end

  def caveats
    <<~EOS
      Audio setup required:

      1. Install audio loopback:
         brew install --cask blackhole-2ch
      2. Reboot your Mac (BlackHole driver needs restart).
      3. Open Audio MIDI Setup.app (in /System/Applications/Utilities).
      4. Create Multi-Output Device:
         + → Create Multi-Output Device → check BlackHole 2ch + your speakers.
      5. Create Aggregate Device:
         + → Create Aggregate Device → check BlackHole 2ch + your microphone.
      6. System Settings → Sound → Output → select Multi-Output Device.
      7. Set your OpenAI key:
         echo 'OPENAI_API_KEY=sk-...' > ~/.capture-pipeline.env

      Launch:
        capture-pipeline

      To uninstall:
        brew uninstall capture-pipeline
        brew untap dsk53910/capture-pipeline
        brew uninstall --cask blackhole-2ch  # optional

      Note: ~/.capture-pipeline.env and output/ files are left intact.
    EOS
  end

  test do
    system "uv", "run", "--directory", libexec, "python", "-c", <<~PYTHON
      from capture import ScreenCapture, AudioCapture
      from processor import VisionProcessor, AudioProcessor, Translator, Summarizer
      print("OK")
    PYTHON
  end
end
