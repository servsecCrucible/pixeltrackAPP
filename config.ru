#\ -p 9393
Dir.glob('./{services,views,controllers}/init.rb').each do |file|
    require file
end

run PixelTrackApp
