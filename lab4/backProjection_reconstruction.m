function G = backProjection_reconstruction(data)
    laser_origin = data.laserOrigin;
    spad_origin = data.spadOrigin;

    x_l = data.laserPositions;
    x_s = data.spadPositions;

    v_c = data.volumePosition;
    v_s = data.volumeSize;

    resolution = 16;

    G = zeros(resolution, resolution, resolution);

    for v_i = 1:resolution
        for v_j = 1:resolution
            for v_k = 1:resolution
                center = v_c - 0.5 * [v_s; v_s; v_s] + [v_i; v_j; v_k] * v_s / resolution;
                for l_i = 1:size(x_l, 1)
                    for l_j = 1:size(x_l, 2)
                        for s_i = 1:size(x_s, 1)
                            for s_j = 1:size(x_s, 2)
                                l = x_l(l_i, l_j, :);
                                s = x_s(s_i, s_j, :);
                                l = l(:);
                                s = s(:);
                                d1 = norm(laser_origin(:) - l);
                                d2 = norm(spad_origin(:) - s);
                                d3 = norm(l - center(:));
                                d4 = norm(s - center(:));

                                t = (d1 + d2 + d3 + d4);

                                index = round(t / data.deltaT) + data.t0;

                                G(v_i, v_j, v_k) = G(v_i, v_j, v_k) + data.data(l_i, l_j, s_i, s_j, index);
                            end
                        end
                    end
                end
            end
        end
    end

    
    
end