#\ -p 9393
Dir.glob('./{services,views,controllers,config}/init.rb').each do |file|
    require file
end

run PixelTrackApp
