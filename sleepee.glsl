#define PI 3.14159265359

mat2 Rot(float a) {
    float s=sin(a), c=cos(a);
    return mat2(c, -s, s, c);
}

float Hash21(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

vec3 palette( in float t )
{
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(2.0, 1.0, 1.0);
    vec3 d = vec3(0.50, 0.20, 0.25);

    return a + b*cos( 6.28318*(c*t+d) );
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    uv *= 1.-fract(Hash21(vec2(1., 2.5)));
    
    vec2 gv = uv;
    gv *= fract(gv)*.3;
    
    float t = iTime*.05*(Hash21(vec2(.3, 2.7)));
    gv *= Rot(t);
    
    float d = length(uv) * .5-length(uv); // change colour and pattern
    d = length(uv) * 1.-fract(abs(gv.x * gv.y*450.));
    vec3 col = palette(d);
    
    float rays = fract(gv.x * gv.y*150.);
    rays = 1.*cos(abs(gv.x * gv.y*250.));
    col += smoothstep(.2, .8, rays);
    
    // Time varying pixel color
    col += 0.25 + 1.5*cos(iTime+uv.xyx+vec3(0,2,4));
    
    // Output to screen
    fragColor = vec4(col,1.0);
}