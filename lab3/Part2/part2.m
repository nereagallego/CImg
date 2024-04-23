% load HDR
% hdr = hdrread('../Part1/Results/no_weights/hdr_image.hdr');
hdr = hdrread('../Part1/Results/tent_weights/hdr_image.hdr');



% tone-map
keys=[0.09, 0.18, 0.36, 0.720];
burns=[0.1, 0.5, 1, 3];

fignum = 3;

for key=keys

    imwrite( ...
        reinhard_tonemapping(hdr, key, 1, fignum), ...
        "Results/tonemapped_reinhard_key_" + key + ".png" ...
        )

end

for burn=burns

    imwrite( ...
        reinhard_tonemapping(hdr, keys(1), burn, fignum+1), ...
        "Results/tonemapped_reinhard_burn_" + burn + ".png" ...
        )

end

simple_hdr = scale_and_gamma(hdr ./ (1 + hdr));

clf(figure(fignum+2))
figure(fignum+2)
imagesc(simple_hdr)
axis image;
    
imwrite(simple_hdr, "Results/simple_hdr.png")

clear fignum key burn;
