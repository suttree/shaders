mat2 Rot(float a) {
    float s=sin(a), c=cos(a);
    return mat2(c, -s, s, c);
}

vec3 palette( in float t )
{
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 0.7, 0.4);
    vec3 d = vec3(0.00, 0.15, 0.20);

    return a + b*cos( 6.28318*(c*t+d) );
}

float Hash21(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 uv0 = uv;
    
    uv *= 5.; // zoom out
    
    vec2 gv = fract(uv)-.5; // create grid vector and offset origin to center
    vec2 id = floor(uv); // an id for each box in the grid
    
    vec3 col = palette(length(id) - sin(iTime*.25) - Hash21(floor(gv)));
    
    fragColor = vec4(col,1.0);
}