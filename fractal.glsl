void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    float angle = iTime * 0.031472;
    vec2 normalizedCoord = fragCoord / iResolution.xy * 2.0 - 1.0;

    for (float i = 0.; i < 24.; i += 1.) {
        normalizedCoord = abs(normalizedCoord);
        normalizedCoord -= 0.8;
        normalizedCoord *= 1.2;
        normalizedCoord *= mat2(
            cos(angle), -sin(angle),
            sin(angle), cos(angle)
        );
    }

    fragColor = vec4( length(normalizedCoord),
       length(normalizedCoord + vec2(0.4, -0.8)),
       length(normalizedCoord + vec2(-0.2, 0.9)), 1.); 
}
