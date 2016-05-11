#\ -p 9393
Dir.glob('./{lib,services,views,controllers,config}/init.rb').each do |file|
    require file
end

run PixelTrackApp
