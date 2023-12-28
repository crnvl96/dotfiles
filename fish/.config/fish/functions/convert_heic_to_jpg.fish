function convert_heic_to_jpg
    for f in *.heic
        heif-convert -q 100 $f $f.jpg
    end
end
