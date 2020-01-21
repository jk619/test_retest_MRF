function do_16_plot_betas(directory4glm)



subj_dir = '/data/struct3T';
subj        = dir(sprintf('./%s/',subj_dir));
subj        = subj(~ismember({subj(:).name},{'.','..','.DS_Store'}));
sites       = dir('./data/*_*');
sites       = sites([sites(:).isdir]==1);

leg = subj(1)
leg.name = 'Mean'

leg = cat(1,leg,subj,sites);
leg(end+1).name = 'test';
leg(end+1).name = 'retest';

figure(1);

betas = dir(sprintf('%s/*beta*',directory4glm))

for b = 1 : length(betas)
    
    subplot(3,6,b)
    beta = load_nii(sprintf('%s/%s',directory4glm,betas(b).name))
    imagesc(beta.img(:,:,60)); title(leg(b).name); axis image; axis off; colorbar
    
end
    set(gcf,'Position',[1 1 1680 999])
end
