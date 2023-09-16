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

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 uv0 = uv;
    
    uv *= 3.; // zoom out
    
    vec2 gv = fract(uv)-.5; // create grid vector and offset origin to center
    vec2 id = floor(uv); // an id for each box in the grid
    
    vec2 gv0 = gv;
    
    vec3 col = palette(length(gv) - iTime*.25);
    gv *= .3;

    // use gv rather than uv to reference each box in the grid
    float d = length(gv);
    float m = .02/d;
    col += m;
    
    float rays = max(0., 1.-abs(gv.x*gv.y*1000.));
    col += rays;
    
    uv *= Rot(3.1475/4.);
    rays = max(0., 1.-abs(gv.x*gv.y*1000.));
    col += rays*.3; // dimmer 
    
    fragColor = vec4(col,1.0);
}