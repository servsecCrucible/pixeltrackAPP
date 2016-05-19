#\ -p 9393
Dir.glob('./{config,controllers,forms,lib,services,views}/init.rb').each do |file|
    require file
end

run PixelTrackApp
