class CarouselFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
        sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        let centerX = collectionView?.contentOffset.x ?? 0
        let width = collectionView?.bounds.width ?? 0
        let offsetX = centerX + width / 2

        attributes.forEach { attribute in
            let distance = abs(attribute.center.x - offsetX)
            let scale = max(0.8, 1 - distance / width * 0.3)
            attribute.transform = CGAffineTransform(scaleX: scale, y: scale)
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}